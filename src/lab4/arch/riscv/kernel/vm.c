#include "stdint.h"
#include "printk.h"
#include "defs.h"
#include <string.h>
extern char _stext[];
extern char _etext[];
extern char _srodata[];
extern char _erodata[];
extern char _sdata[];
/* early_pgtbl: 用于 setup_vm 进行 1GiB 的映射 */
uint64_t early_pgtbl[512] __attribute__((__aligned__(0x1000)));

void setup_vm() {
    /* 
     * 1. 由于是进行 1GiB 的映射，这里不需要使用多级页表 
     * 2. 将 va 的 64bit 作为如下划分： | high bit | 9 bit | 30 bit |
     *     high bit 可以忽略
     *     中间 9 bit 作为 early_pgtbl 的 index
     *     低 30 bit 作为页内偏移，这里注意到 30 = 9 + 9 + 12，即我们只使用根页表，根页表的每个 entry 都对应 1GiB 的区域
     * 3. Page Table Entry 的权限 V | R | W | X 位设置为 1
    **/
    for (int i = 0; i < 512; i++) {
        if(i==2) early_pgtbl[i] = (uint64_t)0x2000000F;
        else if (i==384) early_pgtbl[i] = (uint64_t)0x2000000F;
        else early_pgtbl[i] = (uint64_t)0x0;
    }
}

/* swapper_pg_dir: kernel pagetable 根目录，在 setup_vm_final 进行映射 */
uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));

void setup_vm_final() {
    memset(swapper_pg_dir, 0x0, PGSIZE);

    // No OpenSBI mapping required
    for (int i = 0; i < 512; i++) {
        swapper_pg_dir[i] = (uint64_t)0x0;
    }
    // mapping kernel text X|-|R|V
    create_mapping(
        swapper_pg_dir, 
        (uint64_t)_stext, 
        (uint64_t)((uint64_t)_stext-PA2VA_OFFSET), 
        (uint64_t)((uint64_t)_etext-(uint64_t)_stext), 
        (uint64_t)0x0B
    );

    // mapping kernel rodata -|-|R|V
    create_mapping(
        swapper_pg_dir, 
        (uint64_t)_srodata, 
        (uint64_t)((uint64_t)_srodata-PA2VA_OFFSET), 
        (uint64_t)((uint64_t)_erodata-(uint64_t)_srodata), 
        (uint64_t)0x03
    );

    // mapping other memory -|W|R|V
    create_mapping(
        swapper_pg_dir, 
        (uint64_t)_sdata, 
        (uint64_t)((uint64_t) _sdata-PA2VA_OFFSET), 
        (uint64_t)(PHY_END+PA2VA_OFFSET-(uint64_t)_sdata), 
        (uint64_t)0x07
    );

    // set satp with swapper_pg_dir
    uint64_t virtual = (uint64_t)swapper_pg_dir-PA2VA_OFFSET;
    uint64_t value = (uint64_t)(virtual>>12);
    value += 0x8000000000000000;
    csr_write(satp, value);
    // flush TLB
    asm volatile("sfence.vma zero, zero");
    return;
}


/* 创建多级页表映射关系 */
/* 不要修改该接口的参数和返回值 */
void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm) {
    /*
     * pgtbl 为根页表的基地址
     * va, pa 为需要映射的虚拟地址、物理地址
     * sz 为映射的大小，单位为字节
     * perm 为映射的权限（即页表项的低 8 位）
     * 
     * 创建多级页表的时候可以使用 kalloc() 来获取一页作为页表目录
     * 可以使用 V bit 来判断页表项是否存在
    **/
    uint64_t vpn0 = ((uint64_t)va<<43)>>55;
    uint64_t vpn1 = ((uint64_t)va<<34)>>55;
    uint64_t vpn2 = ((uint64_t)va<<25)>>55;
    uint64_t *pgtbl_entry = &pgtbl[vpn2];
    uint64_t *second_pgtbl;
    //创建二级页表
    if(!(*pgtbl_entry & 0x1)) {
        //这里新的kalloc出来的是虚拟地址
        uint64_t *new_pgtbl = (uint64_t *)kalloc();
        // printk("new_pgtbl = %lx\n", new_pgtbl);
        //这里存进页表项的是物理地址
        uint64_t phy_pgt = (uint64_t)((uint64_t)new_pgtbl - PA2VA_OFFSET)>>12;
        // printk("phy_pgt = %lx\n", phy_pgt);
        *pgtbl_entry = phy_pgt;
        *pgtbl_entry = (uint64_t)((*pgtbl_entry << 10) + 0x1);   
        second_pgtbl = new_pgtbl; 
    }
    //找到二级页表的物理地址，然后转化成虚拟地址去访问
    else {
        second_pgtbl = (uint64_t*)((uint64_t)(*pgtbl_entry<<10)>>20<<12);
        second_pgtbl = (uint64_t *)((uint64_t)second_pgtbl + PA2VA_OFFSET);
    }
    uint64_t count = 0;
    while ((signed)sz > 0) {
        uint64_t huge_pgsize = 0x200000;//2MiB
        uint64_t *second_pgtbl_entry = &second_pgtbl[vpn1];
        uint64_t *third_pgtbl;
        if (!(*second_pgtbl_entry & 0x1)) {
            uint64_t *new_pgtbl = (uint64_t *)kalloc();
            uint64_t phy_pgt = (uint64_t)((uint64_t) new_pgtbl - PA2VA_OFFSET)>>12;
            *second_pgtbl_entry = phy_pgt;
            *second_pgtbl_entry = (uint64_t)((*second_pgtbl_entry << 10)+0x1);
            third_pgtbl = new_pgtbl;
        }
        else {
            third_pgtbl = (uint64_t*)((uint64_t)(*second_pgtbl_entry<<10)>>20<<12);
            third_pgtbl = (uint64_t *)((uint64_t)third_pgtbl + PA2VA_OFFSET);
        }
        uint64_t entries = huge_pgsize/PGSIZE;//2MiB/4KiB=512
        while((signed)sz > 0 && vpn0 < entries) {
            uint64_t *third_pgtbl_entry = &third_pgtbl[vpn0];
            if (!(*third_pgtbl_entry & 0x1)) {
                *third_pgtbl_entry = (uint64_t)(pa + count*PGSIZE)>>12;
                *third_pgtbl_entry = (uint64_t)((*third_pgtbl_entry << 10)+perm);
                // third_pgtbl[vpn0] = *third_pgtbl_entry;
                count++;
                sz -= PGSIZE;
            } else {
                *third_pgtbl_entry = (uint64_t)((*third_pgtbl_entry>>10<<10)+perm);
            }
            vpn0++;
        }
        vpn1++;
        vpn0 = 0;
    }
    

}

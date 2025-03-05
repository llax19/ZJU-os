#include "mm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"
#include "string.h"
#include "syscall.h"
#include "elf.h"
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];
extern uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);
extern void __ret_from_fork();
struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此
uint64_t nr_tasks=2;
uint64_t proc_pg_dir[NR_TASKS][512] __attribute__((__aligned__(0x1000)));

uint64_t do_fork(struct pt_regs *regs) {
    char *PageLow = (char *)kalloc();
    memcpy(PageLow, (char*)current, PGSIZE);
    task[nr_tasks] = (struct task_struct *)PageLow;
    task[nr_tasks]->pid = nr_tasks;
    task[nr_tasks]->mm.mmap = NULL;
    struct mm_struct *mm = &current->mm;
    struct vm_area_struct *vma = mm->mmap;
    memcpy(proc_pg_dir[nr_tasks], swapper_pg_dir, PGSIZE);
    task[nr_tasks]->pgd = proc_pg_dir[nr_tasks];
    while (vma != NULL){
        struct vm_area_struct *new_vma = (struct vm_area_struct *)kalloc();
        memcpy((char*)new_vma, (char*)vma, PGSIZE);
        //插入到子进程的mmap链表中
        if (task[nr_tasks]->mm.mmap != NULL) {
            new_vma->vm_next = task[nr_tasks]->mm.mmap;
        } else {
            new_vma->vm_next = NULL;
        }
        task[nr_tasks]->mm.mmap = new_vma;
        //遍历该vma中的每一页，通过页表检查是否有效，有效的话复制那一页的内容并创建映射
        for (uint64_t pg_loc = vma->vm_start; pg_loc < vma->vm_end; pg_loc =PGROUNDDOWN(pg_loc+PGSIZE)){
            uint64_t *pte = get_pte(current->pgd, pg_loc);
            if (pte != NULL){
                uint64_t pte_val = *pte;
                char *new_page = (char *)kalloc();
                char *old_page = (char *)((pte_val<<10)>>20<<12) + PA2VA_OFFSET;
                memcpy(new_page, old_page, PGSIZE);
                create_mapping(
                    task[nr_tasks]->pgd, 
                    pg_loc, 
                    (uint64_t)new_page-PA2VA_OFFSET, 
                    PGSIZE, 
                    (uint64_t)((vma->vm_flags) | 0x11)
                );
            }
        }
        vma = vma->vm_next;
    }
    task[nr_tasks]->thread.ra = __ret_from_fork;
    //处理sp问题
    uint64_t pt_regs_offset = regs->x2 - (uint64_t)current;
    struct pt_regs *child_regs = (struct pt_regs *)((uint64_t)task[nr_tasks] + pt_regs_offset);
    child_regs->x2 = (uint64_t)task[nr_tasks] + pt_regs_offset;
    child_regs->x10 = 0;
    child_regs->sepc += 4; 
    //这个应该是自己的内核栈的pt_regs的地址，因为在__switch_to赋完值之后，会跳到_traps里面
    task[nr_tasks]->thread.sp = child_regs->x2;
    task[nr_tasks]->thread.sscratch = csr_read(sscratch);
    Log("[PID = %d] forked from PID=%d", task[nr_tasks]->pid, current->pid);
    return nr_tasks++;
}
void do_page_fault(struct pt_regs *regs, uint64_t scause) {
    uint64_t bad_addr = regs->stval;
    struct vm_area_struct * vma = find_vma(&current->mm, bad_addr);
    if (vma == NULL) {
        Err(RED "Page fault at addr=0x%x, scause=0x%x, but no mapping found\n", bad_addr, scause);
    } else if (!(vma->vm_flags & VM_READ)) {
        Err("Read denied\n");
    } else if (!(vma->vm_flags & VM_WRITE) && scause==15) {
        Err("Store instruction but write denied.\n");
    } else if (!(vma->vm_flags & VM_EXEC) && scause==12) {
        Err("Exec instruction but exec dedied.\n");
    }
    char *page = (char *)kalloc();
    //如果正好跳转到页中间得把整个页加载进来，所以要比较页顶和vma->vm_start的大小
    if (vma->vm_start != bad_addr) {
        bad_addr = PGROUNDDOWN(bad_addr);
    }
    uint64_t bad_end = PGROUNDDOWN(bad_addr) + 0x1000;
    bad_end = vma->vm_end>bad_end?bad_end:vma->vm_end;
    uint64_t length = bad_end - bad_addr;
    uint64_t offset = (uint64_t)(bad_addr & 0xFFF);
    if (vma->vm_flags & VM_ANON) {
        memset(page, 0, PGSIZE);
    } else {
        // uint64_t file_size = vma->vm_filesz;
        uint64_t file_start = vma->vm_pgoff + (uint64_t) _sramdisk;
        uint64_t file_offset = bad_addr - vma->vm_start;
        uint64_t file_length = length;
        if(file_offset + length > vma->vm_filesz){
            file_length = (vma->vm_filesz>file_offset)?(vma->vm_filesz-file_offset):0;
        }
        memcpy(page + offset, (char *)(file_start + file_offset), file_length);
        memset(page + offset + file_length, 0, length - file_length);
    }
    create_mapping(
        current->pgd, 
        PGROUNDDOWN(bad_addr), 
        (uint64_t)page-PA2VA_OFFSET, 
        length, 
        (uint64_t)((vma->vm_flags) | 0x11)
    );
}

uint64_t do_mmap(struct mm_struct *mm, uint64_t addr, uint64_t len, 
                    uint64_t vm_pgoff, uint64_t vm_filesz, uint64_t flags){
    struct vm_area_struct *vma = mm->mmap;
    struct vm_area_struct *new_vma = (struct vm_area_struct *)kalloc();
    new_vma->vm_start = addr;
    new_vma->vm_end = addr + len;
    new_vma->vm_pgoff = vm_pgoff;
    new_vma->vm_filesz = vm_filesz;
    new_vma->vm_flags = flags;
    mm->mmap = new_vma;
    new_vma->vm_next = vma;
    return addr;
}

struct vm_area_struct *find_vma(struct mm_struct *mm, uint64_t addr){
    struct vm_area_struct *vma = mm->mmap;
    while (vma != NULL){
        if (vma->vm_start <= addr && vma->vm_end > addr){
            return vma;
        }
        vma = vma->vm_next;
    }
    return NULL;
}

void load_program(struct task_struct *task) {
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    uint64_t offset = (uint64_t)(ehdr->e_entry&0xFFF);
    for (int i = 0; i < ehdr->e_phnum; ++i) {
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD) {
            Log("ELF mem_start: 0x%lx, mem_end: 0x%lx, file_end: 0x%lx", 
                phdr->p_vaddr, phdr->p_vaddr + phdr->p_memsz, phdr->p_vaddr + phdr->p_filesz);
            do_mmap(&task->mm, phdr->p_vaddr, phdr->p_memsz, phdr->p_offset, phdr->p_filesz, (uint64_t)(phdr->p_flags<<1));
        }
    }
    task->thread.sepc = (uint64_t)ehdr->e_entry;
}

void task_init() {
    srand(2024);

    // 1. 调用 kalloc() 为 idle 分配一个物理页
    // 2. 设置 state 为 TASK_RUNNING;
    // 3. 由于 idle 不参与调度，可以将其 counter / priority 设置为 0
    // 4. 设置 idle 的 pid 为 0
    // 5. 将 current 和 task[0] 指向 idle
    
    char * PageLow = (char *)kalloc();
    idle = (struct task_struct *)PageLow;
    idle->state = TASK_RUNNING;
    idle->counter = 0;
    idle->priority = 0;
    idle->pid = 0;
    current = idle;
    task[0] = idle;


    // 1. 参考 idle 的设置，为 task[1] ~ task[NR_TASKS - 1] 进行初始化
    // 2. 其中每个线程的 state 为 TASK_RUNNING, 此外，counter 和 priority 进行如下赋值：
    //     - counter  = 0;
    //     - priority = rand() 产生的随机数（控制范围在 [PRIORITY_MIN, PRIORITY_MAX] 之间）
    // 3. 为 task[1] ~ task[NR_TASKS - 1] 设置 thread_struct 中的 ra 和 sp
    //     - ra 设置为 __dummy（见 4.2.2）的地址
    //     - sp 设置为该线程申请的物理页的高地址

    for (int i=1 ;i<nr_tasks; i++){
        char * PageLow = (char *)kalloc();
        task[i] = (struct task_struct *)PageLow;
        task[i]->state = TASK_RUNNING;
        task[i]->counter = 0;
        task[i]->priority = PRIORITY_MIN + rand() % (PRIORITY_MAX - PRIORITY_MIN + 1);
        task[i]->pid = i;
        task[i]->thread.ra = (uint64_t)__dummy;
        task[i]->thread.sp = (uint64_t)PageLow + PGSIZE;
        //SPP 8,SPIE 5,SUM 18
        //SPP is set to 0 to return user mode, SPIE is set to 1 to enable interrupts after sret, and SUM is set to 1 to allow S-mode access to U-mode memory.
        // task[i]->thread.sepc = (uint64_t)USER_START;
        task[i]->thread.sstatus = 0x40020;
        task[i]->thread.sscratch = (uint64_t)USER_END;//sp of U-mode

        memcpy(proc_pg_dir[i], swapper_pg_dir, PGSIZE);

        // uint64_t char_count = (uint64_t)_eramdisk - (uint64_t)_sramdisk;
        // uint64_t page_count = (char_count + PGSIZE - 1) / PGSIZE;
        // char *suapp = (char *)alloc_pages(page_count);

        // memcpy(suapp, _sramdisk, char_count);

        // create_mapping(
        //     proc_pg_dir[i], 
        //     (uint64_t)USER_START,
        //     (uint64_t)((uint64_t)(suapp)-PA2VA_OFFSET), 
        //     (uint64_t)(page_count*PGSIZE), 
        //     0x1F
        // );
        load_program(task[i]);
        
        // uint64_t *stack = (uint64_t *)kalloc();
        // create_mapping(
        //     proc_pg_dir[i], 
        //     (uint64_t)USER_END-PGSIZE,
        //     (uint64_t)stack-PA2VA_OFFSET, 
        //     (uint64_t) PGSIZE, 
        //     0x17
        // ); 
        do_mmap(&task[i]->mm, USER_END-PGSIZE, PGSIZE, 0, 0, VM_ANON | VM_READ | VM_WRITE);
        // uint64_t virtual = (uint64_t)proc_pg_dir[i]-PA2VA_OFFSET;
        // uint64_t value = (uint64_t)(virtual>>12);
        // value += 0x8000000000000000;
        task[i]->pgd = proc_pg_dir[i];
    }

    printk("...task_init done!\n");
}

#if TEST_SCHED
#define MAX_OUTPUT ((nr_tasks - 1) * 10)
char tasks_output[MAX_OUTPUT];
int tasks_output_index = 0;
char expected_output[] = "2222222222111111133334222222222211111113";
#include "sbi.h"
#endif

void dummy() {
    uint64_t MOD = 1000000007;
    uint64_t auto_inc_local_var = 0;
    int last_counter = -1;
    printk("First in dummy: current counter = %d\n", current->counter);
    while (1) {
        if ((last_counter == -1 || current->counter != last_counter) && current->counter > 0) {
            if (current->counter == 1) {
                --(current->counter);   // forced the counter to be zero if this thread is going to be scheduled
            }                           // in case that the new counter is also 1, leading the information not printed.
            last_counter = current->counter;
            auto_inc_local_var = (auto_inc_local_var + 1) % MOD;
            printk("[PID = %d] is running. auto_inc_local_var = %d, current counter = %d\n", current->pid, auto_inc_local_var, current->counter);
            #if TEST_SCHED
            tasks_output[tasks_output_index++] = current->pid + '0';
            if (tasks_output_index == MAX_OUTPUT) {
                for (int i = 0; i < MAX_OUTPUT; ++i) {
                    if (tasks_output[i] != expected_output[i]) {
                        printk("\033[31mTest failed!\033[0m\n");
                        printk("\033[31m    Expected: %s\033[0m\n", expected_output);
                        printk("\033[31m    Got:      %s\033[0m\n", tasks_output);
                        sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
                    }
                }
                printk("\033[32mTest passed!\033[0m\n");
                printk("\033[32m    Output: %s\033[0m\n", expected_output);
                sbi_system_reset(SBI_SRST_RESET_TYPE_SHUTDOWN, SBI_SRST_RESET_REASON_NONE);
            }
            #endif
        }
    }
}

extern void __switch_to(struct task_struct *prev, struct task_struct *next);

void switch_to(struct task_struct *next) {
    if (current != next) {
        struct task_struct *prev = current;
        current = next;
        printk("Switch to PID=%d counter=%d priority=%d\n", current->pid, current->counter, current->priority);
        __switch_to(prev, current);
        
    }
}

void do_timer() {
    // 1. 如果当前线程是 idle 线程或当前线程时间片耗尽则直接进行调度
    // 2. 否则对当前线程的运行剩余时间减 1，若剩余时间仍然大于 0 则直接返回，否则进行调度
    if (current == idle || current->counter == 0) {
        schedule();
    } else {
        if (--current->counter) {
            return;
        } else {
            schedule();
        }
    }
}

void schedule() {
    uint64_t max_counter = 0;
    struct task_struct *next = NULL;
    for (int i=0; i<nr_tasks; i++){
        if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
            max_counter = task[i]->counter;
            next = task[i];
        }
    }
    if (max_counter == 0) {
        for (int i=0; i<nr_tasks; i++) {
            task[i]->counter = task[i]->priority;
            printk("SET [PID = %d counter = %d priority = %d]\n", task[i]->pid, task[i]->counter, task[i]->priority);
        }
        for (int i=0; i<nr_tasks; i++){
            if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
                max_counter = task[i]->counter;
                next = task[i];
            }
        }
    }
    if (next == NULL) {
        printk("Error: no available thread to run!\n");
        next = idle;
    }
    switch_to(next);
}

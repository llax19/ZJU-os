#include "mm.h"
#include "defs.h"
#include "proc.h"
#include "stdlib.h"
#include "printk.h"
#include "string.h"
#include "elf.h"
extern void __dummy();
extern char _sramdisk[];
extern char _eramdisk[];
extern uint64_t swapper_pg_dir[512] __attribute__((__aligned__(0x1000)));
extern void create_mapping(uint64_t *pgtbl, uint64_t va, uint64_t pa, uint64_t sz, uint64_t perm);

struct task_struct *idle;           // idle process
struct task_struct *current;        // 指向当前运行线程的 task_struct
struct task_struct *task[NR_TASKS]; // 线程数组，所有的线程都保存在此

uint64_t proc_pg_dir[NR_TASKS][512] __attribute__((__aligned__(0x1000)));

void load_program(struct task_struct *task) {
    Elf64_Ehdr *ehdr = (Elf64_Ehdr *)_sramdisk;
    Elf64_Phdr *phdrs = (Elf64_Phdr *)(_sramdisk + ehdr->e_phoff);
    uint64_t offset = (uint64_t)(ehdr->e_entry&0xFFF);
    for (int i = 0; i < ehdr->e_phnum; ++i) {
        Elf64_Phdr *phdr = phdrs + i;
        if (phdr->p_type == PT_LOAD) {
            uint64_t page_count = (phdr->p_memsz + offset + PGSIZE - 1) / PGSIZE;
            char *seg = (char *)alloc_pages(page_count);
            memcpy((seg+offset), _sramdisk+phdr->p_offset, phdr->p_filesz);
            memset(seg+offset+phdr->p_filesz, 0, phdr->p_memsz - phdr->p_filesz);
            create_mapping(
                proc_pg_dir[task->pid], 
                phdr->p_vaddr, 
                (uint64_t)seg-PA2VA_OFFSET, 
                phdr->p_memsz, 
                (uint64_t)((phdr->p_flags<<1) | 0x11)
            );
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

    for (int i=1 ;i<NR_TASKS; i++){
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
        
        uint64_t *stack = (uint64_t *)kalloc();
        create_mapping(
            proc_pg_dir[i], 
            (uint64_t)USER_END-PGSIZE,
            (uint64_t)stack-PA2VA_OFFSET, 
            (uint64_t) PGSIZE, 
            0x17
        ); 
        // uint64_t virtual = (uint64_t)proc_pg_dir[i]-PA2VA_OFFSET;
        // uint64_t value = (uint64_t)(virtual>>12);
        // value += 0x8000000000000000;
        task[i]->pgd = proc_pg_dir[i];
        
    }

    printk("...task_init done!\n");
}

#if TEST_SCHED
#define MAX_OUTPUT ((NR_TASKS - 1) * 10)
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
    for (int i=0; i<NR_TASKS; i++){
        if (task[i]->state == TASK_RUNNING && task[i]->counter > max_counter){
            max_counter = task[i]->counter;
            next = task[i];
        }
    }
    if (max_counter == 0) {
        for (int i=0; i<NR_TASKS; i++) {
            task[i]->counter = task[i]->priority;
            printk("SET [PID = %d counter = %d priority = %d]\n", task[i]->pid, task[i]->counter, task[i]->priority);
        }
        for (int i=0; i<NR_TASKS; i++){
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

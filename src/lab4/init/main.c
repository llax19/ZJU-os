#include "printk.h"
#include "proc.h"

extern void test();
extern char _stext[];
extern char _srodata[];

int start_kernel() {
    printk("2024");
    printk(" ZJU Operating System\n");

    // printk("text = %c\n", _stext[1]);
    // printk("rodata = %c\n", _srodata[1]);
    // _stext[1] = 'X';
    // _srodata[1] = 'X';
    // printk("text after modify= %c\n", _stext[1]);
    // printk("rodata after modify= %c\n", _srodata[1]);
    schedule();
    test();
    return 0;
}

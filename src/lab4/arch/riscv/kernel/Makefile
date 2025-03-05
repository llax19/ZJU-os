ASM_SRC		= $(sort $(wildcard *.S))
C_SRC       = $(sort $(wildcard *.c))
OBJ		    = $(patsubst %.S,%.o,$(ASM_SRC)) $(patsubst %.c,%.o,$(C_SRC))

all:$(OBJ)

# clock.o: clock.c sbi.c
# 	$(CC) $(CFLAGS) -c $< -o $@

# entry.o: entry.S
# 	$(CC) $(CFLAGS) -c $< -o $@

# trap.o: trap.c
# 	$(CC) $(CFLAGS) -c $< -o $@

# head.o: head.S entry.S
# 	$(CC) $(CFLAGS) -c $< -o $@

# sbi.o: sbi.c
# 	$(CC) $(CFLAGS) -c $< -o $@

%.o:%.S
	${GCC}  ${CFLAG} -c $<

%.o:%.c
	${GCC}  ${CFLAG} -c $<

clean:
	$(shell rm *.o 2>/dev/null)

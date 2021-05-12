# add more modules here!
obj-m = kshellcode.o kbof.o
CFLAGS_kbof.o := -fno-stack-protector
KERNEL_VERSION=5.4

all:
	echo $(OBJECTS)
	make -C ../linux-$(KERNEL_VERSION) M=$(PWD) modules

clean:
	make -C ../linux-$(KERNEL_VERSION) M=$(PWD) clean

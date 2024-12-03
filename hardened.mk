CC = clang
CFLAGS = -Xclang -disable-O0-optnone -m32 -fpass-plugin=/opt/CanaryPass.so -std=c99 -fno-zero-initialized-in-bss -fno-stack-protector -Wno-int-conversion -g3 -gdwarf-2

ifdef CODE_COVERAGE
CFLAGS += -fprofile-arcs -ftest-coverage -DCODE_COVERAGE
endif

.PHONY: all clean

all: hardened_srv

hardened_srv: vuln_srv.c
	$(CC) $(CFLAGS) -o hardened_srv vuln_srv.c /opt/rand.o

clean:
	rm -rf *.o *.gcda *.gcno *.gcov vuln_srv

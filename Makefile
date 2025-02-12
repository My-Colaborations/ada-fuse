ADA_FUSE_SYSTEM := $(shell uname -sm | sed "s- -_-g")
export ADA_FUSE_SYSTEM

ifeq ($(ADA_FUSE_SYSTEM),Linux_x86_64)
	SYS_DIR=system/linux64
endif

ifeq ($(ADA_FUSE_SYSTEM),Linux_i686)
	SYS_DIR=system/linux32
endif

ifeq ($(ADA_FUSE_SYSTEM),Darwin_i386)
	SYS_DIR=system/macos
endif

ifeq ($(ADA_FUSE_SYSTEM),Darwin_x86_64)
	SYS_DIR=system/macos
endif

src/fuse-libfuse.ads:setup
	./setup
all:src/fuse-libfuse.ads
	gprbuild -p -f -Pada_fuse

clean:libfuse.gpr
	gprclean -Pada_fuse >/dev/null
	rm -rf obj lib

# Install directory
prefix ?= $(shell which gprbuild 2> /dev/null | sed -e 's/\/bin\/gprbuild.*//')


install: lib/libada_fuse.a libfuse.gpr
	gprinstall -p -Pada_fuse --prefix=$(prefix)
	cp   libfuse.gpr $(prefix)/share/gpr
	
uninstall:
	gprinstall -Pada_fuse --prefix=$(prefix) --uninstall

test:
	${MAKE} -C examples/hello_world/
	${MAKE} -C examples/rotfs all 
	${MAKE} -C examples/rotfs test

#
# PocketSNES for the Miyoo

# Define the applications properties here:

TARGET = pocketsnes/PocketSNES

CROSS_COMPILE := arm-linux-

CC    := $(CROSS_COMPILE)gcc
CXX   := $(CROSS_COMPILE)g++
STRIP := $(CROSS_COMPILE)strip

SYSROOT := $(shell $(CC) --print-sysroot)
SDL_CFLAGS := $(shell $(SYSROOT)/usr/bin/sdl-config --cflags)
SDL_LIBS := $(shell $(SYSROOT)/usr/bin/sdl-config --libs)

INCLUDE = -I src \
		-I sal/linux/include -I sal/include \
		-I src/include \
		-I menu -I src/linux -I src/snes9x

CCFLAGS =  $(INCLUDE) -DRC_OPTIMIZED -D__LINUX__ -D__DINGUX__ -D_FAST_GFX -D__ARM__ -DFOREVER_16_BIT  $(SDL_CFLAGS)
CCFLAGS += -Ofast -march=armv5te -mtune=arm926ej-s
CCFLAGS += --fast-math -fomit-frame-pointer -fno-strength-reduce -falign-functions=2 -fno-stack-protector

CFLAGS = --std=gnu11 $(CCFLAGS)
CXXFLAGS = --std=gnu++11 $(CCFLAGS) -fno-exceptions -fno-rtti -fno-math-errno -fno-threadsafe-statics

LDFLAGS = -lpthread -lz -lpng $(SDL_LIBS) -Wl,--as-needed -Wl,--gc-sections -s

ifeq ($(PGO), GENERATE)
  CCFLAGS += -fprofile-generate -fprofile-dir=./profile
  LDFLAGS += -lgcov
else ifeq ($(PGO), APPLY)
  CCFLAGS += -fprofile-use -fprofile-dir=./profile -fbranch-probabilities
endif

# Find all source files
SOURCE = src/snes9x menu sal/linux sal
SRC_CPP = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.cpp))
SRC_C   = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.c))
SRC_ASM = $(foreach dir, $(SOURCE), $(wildcard $(dir)/*.S))
OBJ_CPP = $(patsubst %.cpp, %.o, $(SRC_CPP))
OBJ_C   = $(patsubst %.c, %.o, $(SRC_C))
OBJ_ASM = $(patsubst %.S, %.o, $(SRC_ASM))
OBJS    = $(OBJ_CPP) $(OBJ_C) $(OBJ_ASM)

.PHONY : all
all : $(TARGET)

$(TARGET) : $(OBJS)
	$(CXX) $(CXXFLAGS) $^ $(LDFLAGS) -o $@
	$(STRIP) $(TARGET)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.cpp
	$(CXX) $(CXXFLAGS) -c $< -o $@

%.o: %.S
	$(CXX) $(INCLUDES) $(CXXFLAGS) $(LDFLAGS) -Wa,-I./src/ -c $< -o $@

.PHONY : clean

opk: all
	mksquashfs \
	pocketsnes/default.gcw0.desktop \
	pocketsnes/default.retrofw.desktop \
	pocketsnes/snes.retrofw.desktop \
	pocketsnes/pocketsnes.elf \
	pocketsnes/pocketsnes.dge \
	pocketsnes/pocketsnes.man.txt \
	pocketsnes/pocketsnes.png \
	pocketsnes/backdrop.png \
	pocketsnes/pocketsnes.opk \
	-all-root -noappend -no-exports -no-xattrs

clean :
	rm -f $(OBJS) $(TARGET)

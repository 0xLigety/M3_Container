# Makefile for Basler pylon sample program
.PHONY: all clean

# The program to build
NAME       := BaslerGrabSave

# Installation directories for pylon
PYLON_ROOT ?= /opt/pylon5

# Build tools and flags
LD         := armv7a-hardfloat-linux-gnueabi-g++
CPPFLAGS   := $(shell $(PYLON_ROOT)/bin/pylon-config --cflags) -I/usr/armv7a-hardfloat-gnueabi/usr/include/opencv2/
CXXFLAGS   := #e.g., CXXFLAGS=-g -O0 for debugging
LDFLAGS    := $(shell $(PYLON_ROOT)/bin/pylon-config --libs-rpath)
LDLIBS     := $(shell $(PYLON_ROOT)/bin/pylon-config --libs) -lopencv_core -lopencv_imgproc -lopencv_imgcodecs

# Rules for building
all: $(NAME)

$(NAME): $(NAME).o
	$(LD) $(LDFLAGS) -o $@ $^ $(LDLIBS)

$(NAME).o: $(NAME).cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c -o $@ $<

clean:
	$(RM) $(NAME).o $(NAME)


#   https://github.com/jabelone/OpenCV-for-Pi -> include into arm include / libs into pylon lib or custom lib
#	g++ -I/opt/pylon5/include   -c -o BaslerGrabSave.o BaslerGrabSave.cpp
#	g++ -Wl,--enable-new-dtags -Wl,-rpath,/opt/pylon5/lib -o BaslerGrabSave BaslerGrabSave.o -L/opt/pylon5/lib -Wl,-E -lpylonbase -lpylonutility -lGenApi_gcc_v3_0_Basler_pylon_v5_0 -lGCBase_gcc_v3_0_Basler_pylon_v5_0

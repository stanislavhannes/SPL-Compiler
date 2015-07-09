#
# Makefile for ECO32 linking loader
#

CC = gcc -m32
CFLAGS = -g -Wall
LDFLAGS = -g
LDLIBS = -lm

SRCS = ld.c
OBJS = $(patsubst %.c,%.o,$(SRCS))
BIN = ld

.PHONY:		all clean

all:		$(BIN)

$(BIN):		$(OBJS)
		$(CC) $(LDFLAGS) -o $(BIN) $(OBJS) $(LDLIBS)

%.o:		%.c
		$(CC) $(CFLAGS) -o $@ -c $<

depend.mak:
		$(CC) -MM -MG $(CFLAGS) $(SRCS) > depend.mak

-include depend.mak

clean:
		rm -f *~ $(OBJS) $(BIN) depend.mak

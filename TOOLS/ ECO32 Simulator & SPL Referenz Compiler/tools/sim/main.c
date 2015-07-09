/*
 * main.c -- ECO32 simulator
 */


#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#include "common.h"
#include "console.h"
#include "error.h"
#include "command.h"
#include "instr.h"
#include "cpu.h"
#include "mmu.h"
#include "memory.h"
#include "timer.h"
#include "dspkbd.h"
#include "term.h"
#include "disk.h"
#include "output.h"
#include "graph.h"


static void usage(char *myself) {
  fprintf(stderr, "Usage: %s\n", myself);
  fprintf(stderr, "         [-i]             interactive mode\n");
  fprintf(stderr, "         [-l <prog>]      program file name\n");
  fprintf(stderr, "         [-r <rom>]       ROM image file name\n");
  fprintf(stderr, "         [-d <disk>]      disk image file name\n");
  fprintf(stderr, "         [-t <n>]         n terminals connected (0-%d)\n",
          MAX_NTERMS);
  fprintf(stderr, "         [-g]             graphics controller present\n");
  fprintf(stderr, "         [-c]             console present\n");
  fprintf(stderr, "         [-o <file>]      output device file binding\n");
  fprintf(stderr, "The options -l and -r are mutually exclusive.\n");
  fprintf(stderr, "If both are omitted, interactive mode is assumed.\n");
  exit(1);
}


int main(int argc, char *argv[]) {
  int i;
  char *argp;
  Bool interactive;
  char *progName;
  char *romName;
  char *diskName;
  int numTerms;
  Bool graphics;
  Bool console;
  char *outputName;
  Word initialPC;
  char command[20];
  char *line;

  interactive = false;
  progName = NULL;
  romName = NULL;
  diskName = NULL;
  numTerms = 0;
  graphics = false;
  console = false;
  outputName = NULL;
  for (i = 1; i < argc; i++) {
    argp = argv[i];
    if (*argp != '-') {
      usage(argv[0]);
    }
    argp++;
    switch (*argp) {
      case 'i':
        interactive = true;
        break;
      case 'l':
        if (i == argc - 1 || progName != NULL || romName != NULL) {
          usage(argv[0]);
        }
        progName = argv[++i];
        break;
      case 'r':
        if (i == argc - 1 || romName != NULL || progName != NULL) {
          usage(argv[0]);
        }
        romName = argv[++i];
        break;
      case 'd':
        if (i == argc - 1 || diskName != NULL) {
          usage(argv[0]);
        }
        diskName = argv[++i];
        break;
      case 't':
        if (i == argc - 1) {
          usage(argv[0]);
        }
        i++;
        if (argv[i][0] < '0' || argv[i][0] > '0' + MAX_NTERMS ||
            argv[i][1] != '\0') {
          usage(argv[0]);
        }
        numTerms = argv[i][0] - '0';
        break;
      case 'g':
        graphics = true;
        break;
      case 'c':
        console = true;
        break;
      case 'o':
        if (i == argc - 1 || outputName != NULL) {
          usage(argv[0]);
        }
        outputName = argv[++i];
        break;
      default:
        usage(argv[0]);
    }
  }
  cInit();
  cPrintf("ECO32 Simulator started\n");
  if (progName == NULL && romName == NULL && !interactive) {
    cPrintf("Neither a program to load nor a system ROM was\n");
    cPrintf("specified, so interactive mode is assumed.\n");
    interactive = true;
  }
  initInstrTable();
  timerInit();
  if (console) {
    displayInit();
    keyboardInit();
  }
  termInit(numTerms);
  diskInit(diskName);
  outputInit(outputName);
  if (graphics) {
    graphInit();
  }
  memoryInit(romName, progName);
  mmuInit();
  if (progName != NULL) {
    initialPC = 0xC0000000;
  } else {
    initialPC = 0xC0000000 | ROM_BASE;
  }
  cpuInit(initialPC);
  if (!interactive) {
    cPrintf("Start executing...\n");
    strcpy(command, "c\n");
    execCommand(command);
  } else {
    while (1) {
      line = cGetLine("ECO32 > ");
      if (*line == '\0') {
        break;
      }
      cAddHist(line);
      if (execCommand(line)) {
        break;
      }
    }
  }
  cpuExit();
  mmuExit();
  memoryExit();
  timerExit();
  displayExit();
  keyboardExit();
  termExit();
  diskExit();
  outputExit();
  graphExit();
  cPrintf("ECO32 Simulator finished\n");
  cExit();
  return 0;
}

# Maths Hunter



A RPG game for ICT SBA 2014-2015
Last updated 2014-06-28 0200

## Porting to Linux

### How to run?
Compile:
		pc "Maths Hunter ver0628 Source Code Linux.pas" 
Run:
		./Maths Hunter ver0628 Source Code Linux

### What've been done?
  * Fixed "Parameters or result types cannot contain local type definitions." Compiling Error
  * Deleted function cursoroff, which is not supported on Linux (I guess?)
  * Deleted unused variable
  * Fixed \r bug (x-dimension of map reduced by 1)
  * Shorten delay time

### What's still not fixed?
  * Cursor is not hidden
  * Snake Game

## Dependencies
The following tools (with the binary located in a PATH folder) will be required to build this project:

- Compiler for your microcontroller, such as [xc8](http://www.microchip.com/mplabxc8osx) for PIC 8-bit micros
- Programmer application to load code, such as [pk2cmd](http://ww1.microchip.com/downloads/en/DeviceDoc/pk2cmdv1.20LinuxMacSource.tar.gz) for the Microchip PicKit2 
- [GNU make](https://www.gnu.org/software/make/) Build utility 

## Build It
Building the package (with dependencies installed) can be completed by running `make build` in the project root directory (the folder with the Makefile in it, the one you're probably in right now). This will build the project for the chip using the XC8 compiler.

## Burn It
Loading the application to the chip (with programmer connected) can be completed by running the `make bb` directive, which will both build and burn the program. 




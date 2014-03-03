##############################################
# Project Settings 
##############################################

# Project Name
PROJECT_NAME=MyProjectName

# Target Processor
PROCESSOR=18F14K22

# Programming Voltage (Check your chip's datasheet)
VPP=3.5

##############################################
# Environment Config
##############################################

# Compiler Locations
COMPILER_PATH=/Applications/microchip/xc8/v1.30/bin
COMPILER=${COMPILER_PATH}/xc8

# Programmer Locations
PROGRAMMER_PATH=~/Development/tools/PK2CMD
PROGRAMMER=${PROGRAMMER_PATH}/pk2cmd

# Shell Commands
CP=cp 
MKDIR=mkdir -p
RM=rm -f 
MV=mv 

##############################################
# Directive Variable Definitions
##############################################

# Object Directory
OBJECT_DIR=build

# Distribution Directory
DIST_DIR=dist

# Final Output File
MAP_OUTPUT=${DIST_DIR}/${PROJECT_NAME}.map
HEX_OUTPUT=${DIST_DIR}/${PROJECT_NAME}.hex

# Common build options (taken from MPLABX)
COMMON_OPTIONS=--double=24 --float=24 --emi=wordwrite 
COMMON_OPTIONS+=--opt=default,+asm,+asmfile,-speed,+space,-debug
COMMON_OPTIONS+=--addrqual=ignore 
COMMON_OPTIONS+=--mode=free -P -N255 --warn=0 --asmlist 
COMMON_OPTIONS+=--summary=default,-psect,-class,+mem,-hex,-file 
COMMON_OPTIONS+=--output=default,-inhx032 
COMMON_OPTIONS+=--runtime=default,+clear,+init,-keep,-no_startup,-download,+config,+clib,+plib 
COMMON_OPTIONS+=--output=-mcof,+elf:multilocs 
COMMON_OPTIONS+=--stack=compiled:auto:auto:auto
COMMON_OPTIONS+="--errformat=%f:%l: error: (%n) %s" 
COMMON_OPTIONS+="--warnformat=%f:%l: warning: (%n) %s" 
COMMON_OPTIONS+="--msgformat=%f:%l: advisory: (%n) %s" 

# Compiler Options
COMPILER_OPTIONS=-Iinc --pass1 $(MP_EXTRA_CC_PRE) --chip=$(PROCESSOR) -Q -G ${COMMON_OPTIONS}

# Linker Options
LINKER_OPTIONS=--chip=$(PROCESSOR) -G ${COMMON_OPTIONS}

##############################################
# Compiler 
##############################################

${OBJECT_DIR}/core.p1: src/core.c
	@${MKDIR} ${OBJECT_DIR} 
	@${RM} ${OBJECT_DIR}/core.p1.d 
	@${RM} ${OBJECT_DIR}/core.p1 
	${COMPILER} ${COMPILER_OPTIONS} -o${OBJECT_DIR}/core.p1 src/core.c 
	@-${MV} ${OBJECT_DIR}/core.d ${OBJECT_DIR}/core.p1.d  

${OBJECT_DIR}/periph.p1: src/periph.c
	@${MKDIR} ${OBJECT_DIR} 
	@${RM} ${OBJECT_DIR}/periph.p1.d 
	@${RM} ${OBJECT_DIR}/periph.p1 
	${COMPILER} ${COMPILER_OPTIONS} -o${OBJECT_DIR}/periph.p1 src/periph.c 
	@-${MV} ${OBJECT_DIR}/periph.d ${OBJECT_DIR}/periph.p1.d  

${OBJECT_DIR}/interrupts.p1: src/interrupts.c
	@${MKDIR} ${OBJECT_DIR} 
	@${RM} ${OBJECT_DIR}/interrupts.p1.d 
	@${RM} ${OBJECT_DIR}/interrupts.p1 
	${COMPILER} ${COMPILER_OPTIONS} -o${OBJECT_DIR}/interrupts.p1 src/interrupts.c 
	@-${MV} ${OBJECT_DIR}/interrupts.d ${OBJECT_DIR}/interrupts.p1.d 

${OBJECT_DIR}/main.p1: src/main.c
	@${MKDIR} ${OBJECT_DIR} 
	@${RM} ${OBJECT_DIR}/main.p1.d 
	@${RM} ${OBJECT_DIR}/main.p1 
	${COMPILER} ${COMPILER_OPTIONS} -o${OBJECT_DIR}/main.p1 src/main.c 
	@-${MV} ${OBJECT_DIR}/main.d ${OBJECT_DIR}/main.p1.d 

${OBJECT_DIR}/app.p1: src/app.c
	@${MKDIR} ${OBJECT_DIR} 
	@${RM} ${OBJECT_DIR}/app.p1.d 
	@${RM} ${OBJECT_DIR}/app.p1 
	${COMPILER} ${COMPILER_OPTIONS} -o${OBJECT_DIR}/app.p1 src/app.c 
	@-${MV} ${OBJECT_DIR}/app.d ${OBJECT_DIR}/app.p1.d  

##############################################
# Linker
##############################################

# Objects to build
OBJECT_FILES=${OBJECT_DIR}/main.p1 
OBJECT_FILES+=${OBJECT_DIR}/interrupts.p1 
OBJECT_FILES+=${OBJECT_DIR}/periph.p1 
OBJECT_FILES+=${OBJECT_DIR}/app.p1 
OBJECT_FILES+=${OBJECT_DIR}/core.p1 

${HEX_OUTPUT}: ${OBJECT_FILES}
	@${MKDIR} ${DIST_DIR}
	${COMPILER} ${LINKER_OPTIONS} -o${HEX_OUTPUT} ${OBJECT_FILES}

##############################################
# High Level Directives
##############################################

# build
build: .build-pre
	${MAKE} ${DIST_DIR}/${PROJECT_NAME}.hex

# this makes build: look for changes
.build-pre:

# build and burn
bb: build
	${PROGRAMMER} -PPIC${PROCESSOR} -T -A${VPP} -R -J -M -F ${HEX_OUTPUT}

# burn
burn: 
	${PROGRAMMER} -PPIC${PROCESSOR} -T -A${VPP} -R -J -M -F ${HEX_OUTPUT}

# turn off board
off: 
	${PROGRAMMER} -PPIC${PROCESSOR} 

# reset board
reset-board: 
	${PROGRAMMER} -PPIC${PROCESSOR} -T -A${VPP} -R

# clean
clean:
	${RM} -r ${OBJECT_DIR}
	${RM} -r ${DIST_DIR}
	${RM} funclist
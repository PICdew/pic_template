#include <xc.h>             // XC8 General Include File

#include "app.h"            // application control
#include "core.h"           // pic control
#include "periph.h"         // peripheral control

void main(void) {
    
    // configure PIC
    core_initialize();

    // init all peripherals
    periph_initialize();

    // start app logic
    app_initialize();

    // main program loop
    while (1) app_tick();

}


/**
 *  Copyright (c) 2009, Asmodehn's Corp.
 *  All rights reserved.
 *
 *  Redistribution and use in source and binary forms, with or without
 *  modification, are permitted provided that the following conditions are met:
 *
 *      * Redistributions of source code must retain the above copyright notice,
 * 	    this list of conditions and the following disclaimer.
 *      * Redistributions in binary form must reproduce the above copyright
 * 		notice, this list of conditions and the following disclaimer in the
 * 	    documentation and/or other materials provided with the distribution.
 *      * Neither the name of the Asmodehn's Corp. nor the names of its
 * 	    contributors may be used to endorse or promote products derived
 * 	    from this software without specific prior written permission.
 *
 *  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 *  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
 *  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 *  PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS
 *  BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
 *  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 *  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 *  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
 *  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
 *  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF
 *  THE POSSIBILITY OF SUCH DAMAGE.
 *
 */

#include "ProjectC1/headerC1.h"
#include "ProjectC2/headerC2.h"

#include <stdio.h>
#include <dlfcn.h>

int main ( int argc, char* argv[] )
{
    void* library;
    int (*C3_display)();
    char *err;

    C1_display("test C1");
    C2_display("test C2");

/*
    // Open the libC3 shared library
    library = dlopen("libC3.so", RTLD_NOW);
    if (!library) {
        // handle error, the module wasn't found
        fputs (dlerror(), stderr);
        return 1;
    }

    dlerror(); // clear error code
    // Get the loadFilter function, for loading objects
    C3_display = dlsym(library, "C3_display");
    if ((err = dlerror()) != NULL) {
        // handle error, the symbol wasn't found
        fputs (err, stderr);
        dlclose(library);
        return -1;
    } else {
    // symbol found, its value is in s

        (*C3_display)("test C3");
    }

    dlclose(library);
    */
}

#ifndef PROJECTB_H
#define PROJECTB_H

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

/* This should always be the first of your include statements */
#include "WkPlatform_ProjectB.h"

/*We are depending on projectC, projectDsub and projectEsub */
#include "ProjectC/header.h"
#include "ProjectDsub/header.h"
#include "ProjectEsub/header.h"

/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C"
{
#endif

    WK_ProjectB_API int B_display();

    /* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif

#endif /* PROJECTB_H */
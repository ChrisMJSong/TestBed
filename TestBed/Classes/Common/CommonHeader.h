//
//  CommonHeader.h
//  TestBed
//
//  Created by Chris Song on 18/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

typedef enum {
    ProbeHeadTypeUnknown = -1,
    ProbeHeadTypeConvex = 0,
    ProbeHeadTypeLinear,
    ProbeHeadTypeMicroConvex,
    ProbeHeadTypePhasedArray,
    ProbeHeadTypeMax
}ProbeHeadType;

typedef struct{
    ProbeHeadType headType;
    float radius;           // base on Cm
    float footPrint;        // base on Cm
    float fieldOfView;      // base on Degree
}ProbeHead;

#endif /* CommonHeader_h */

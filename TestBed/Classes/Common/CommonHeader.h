//
//  CommonHeader.h
//  TestBed
//
//  Created by Chris Song on 18/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

#define TARGET_VIEW_HEIGHT  512.0
#define PHYSICAL_HEIGHT (TARGET_VIEW_HEIGHT * 0.8)

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
    float minDepth;         // base on Cm
    float maxDepth;         // base on Cm
    float fieldOfView;      // base on Degree
}ProbeHead;

#endif /* CommonHeader_h */

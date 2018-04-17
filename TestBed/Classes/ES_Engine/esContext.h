//
//  esContext.h
//  GLViewModule
//
//  Created by Chris on 2015. 7. 23..
//  Copyright (c) 2015년 Chris. All rights reserved.
//

#ifndef __GLViewModule__esContext__
#define __GLViewModule__esContext__

#include <stdio.h>
#include <iostream>

#include <stdlib.h>
#include <math.h>
#ifdef __APPLE__
#include <OpenGLES/ES3/gl.h>
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

typedef enum {
    CProbeHeadTypeUnknown = -1,
    CProbeHeadTypeConvex = 0,
    CProbeHeadTypeLinear,
    CProbeHeadTypeMicroConvex,
    CProbeHeadTypePhasedArray,
    CProbeHeadTypeMax
}CProbeHeadType;

typedef struct{
    CProbeHeadType headType;
    float radius;           // base on Cm
    float footPrint;        // base on Cm
    float fieldOfView;      // base on Degree
}GLProbeHead;

typedef struct {
    int width = 320, height = 320;
    float scale = 1.0;
} ViewInfo;

class ESContext {
    ViewInfo _viewInfo;
    
    GLuint _programObject;
    GLuint _textureId;
    GLint _baseMapLoc;
    
    GLfloat *_vVertices;    // B Image frame
    GLushort *_indices;
    GLubyte *_rBuf;         // rBuf: BMode nBuf: Doppler
    bool _textureUpdated;
    float _offsetY;
    
    bool createWindow(const char *title, GLint width, GLint height, GLint flags);
    void createVeritices(GLfloat **buffer, GLProbeHead head, GLuint depth);
    void createVeriticesArc(GLfloat **buffer, GLProbeHead head, GLuint depth);
    void createVeriticesRect(GLfloat **buffer, GLProbeHead head, GLuint depth);
    
    void init();
    GLuint loadTexture(GLubyte *buf, int width, int height);
    GLuint loadRGBTexture(GLubyte *buf, int width, int height);
public:
    // PWOption
    GLProbeHead _probeHead;
    GLuint _depth;
    GLubyte *_tBuf;
    
    ESContext();
    virtual ~ESContext();
    void initWithViewsize(int width, int height);
    void draw();
    void update(GLfloat timeDelta);
    bool updateTexture(GLubyte *buffer, int width, int height);
    int esVersion;
};

#endif /* defined(__GLViewModule__esContext__) */

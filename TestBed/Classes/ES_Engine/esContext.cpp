//
//  esContext.cpp
//  GLViewModule
//
//  Created by Chris on 2015. 7. 23..
//  Copyright (c) 2015년 Chris. All rights reserved.
//

#include "esContext.h"
#include "esUtil.h"
#include <math.h>

#ifdef ANDROID
#include <android/log.h>
#include <android_native_app_glue.h>
#include <android/asset_manager.h>
typedef AAsset esFile;
#else
typedef FILE esFile;
#endif

#ifdef __APPLE__
#include "FileWrapper.h"
#endif


#define SLICE_COUNT     128
#define PRESENT_SCALE   0.8

#define kTotalVertexCount   ((SLICE_COUNT+1)*2)
#define GET_INDEX(n)        ((i-1)*10+(5*(n)))

ESContext::ESContext(){
    _viewInfo = ViewInfo();
    
    _vVertices  = NULL;
    _indices    = NULL;
    _rBuf       = NULL;
}

ESContext::~ESContext(){
    if (_vVertices) {
        free(_vVertices);
        _vVertices = NULL;
    }
    
    if (_indices) {
        free(_indices);
        _indices = NULL;
    }
    
    if (_rBuf) {
        free(_rBuf);
        _rBuf = NULL;
    }
}

bool ESContext::createWindow(const char *title, GLint width, GLint height, GLint flags){
    
#ifndef __APPLE__
    EGLConfig config;
    EGLint majorVersion;
    EGLint minorVersion;
    EGLint contextAttribs[] = { EGL_CONTEXT_CLIENT_VERSION, 3, EGL_NONE };
    
    if ( esContext == NULL )
    {
        return GL_FALSE;
    }
    
#ifdef ANDROID
    // For Android, get the width/height from the window rather than what the
    // application requested.
    esContext->width = ANativeWindow_getWidth ( esContext->eglNativeWindow );
    esContext->height = ANativeWindow_getHeight ( esContext->eglNativeWindow );
#else
    esContext->width = width;
    esContext->height = height;
#endif
    
    if ( !WinCreate ( esContext, title ) )
    {
        return GL_FALSE;
    }
    
    esContext->eglDisplay = eglGetDisplay( esContext->eglNativeDisplay );
    if ( esContext->eglDisplay == EGL_NO_DISPLAY )
    {
        return GL_FALSE;
    }
    
    // Initialize EGL
    if ( !eglInitialize ( esContext->eglDisplay, &majorVersion, &minorVersion ) )
    {
        return GL_FALSE;
    }
    
    {
        EGLint numConfigs = 0;
        EGLint attribList[] =
        {
            EGL_RED_SIZE,       5,
            EGL_GREEN_SIZE,     6,
            EGL_BLUE_SIZE,      5,
            EGL_ALPHA_SIZE,     ( flags & ES_WINDOW_ALPHA ) ? 8 : EGL_DONT_CARE,
            EGL_DEPTH_SIZE,     ( flags & ES_WINDOW_DEPTH ) ? 8 : EGL_DONT_CARE,
            EGL_STENCIL_SIZE,   ( flags & ES_WINDOW_STENCIL ) ? 8 : EGL_DONT_CARE,
            EGL_SAMPLE_BUFFERS, ( flags & ES_WINDOW_MULTISAMPLE ) ? 1 : 0,
            // if EGL_KHR_create_context extension is supported, then we will use
            // EGL_OPENGL_ES3_BIT_KHR instead of EGL_OPENGL_ES2_BIT in the attribute list
            EGL_RENDERABLE_TYPE, GetContextRenderableType ( esContext->eglDisplay ),
            EGL_NONE
        };
        
        // Choose config
        if ( !eglChooseConfig ( esContext->eglDisplay, attribList, &config, 1, &numConfigs ) )
        {
            return GL_FALSE;
        }
        
        if ( numConfigs < 1 )
        {
            return GL_FALSE;
        }
    }
    
    
#ifdef ANDROID
    // For Android, need to get the EGL_NATIVE_VISUAL_ID and set it using ANativeWindow_setBuffersGeometry
    {
        EGLint format = 0;
        eglGetConfigAttrib ( esContext->eglDisplay, config, EGL_NATIVE_VISUAL_ID, &format );
        ANativeWindow_setBuffersGeometry ( esContext->eglNativeWindow, 0, 0, format );
    }
#endif // ANDROID
    
    // Create a surface
    esContext->eglSurface = eglCreateWindowSurface ( esContext->eglDisplay, config,
                                                    esContext->eglNativeWindow, NULL );
    
    if ( esContext->eglSurface == EGL_NO_SURFACE )
    {
        return GL_FALSE;
    }
    
    // Create a GL context
    esContext->eglContext = eglCreateContext ( esContext->eglDisplay, config,
                                              EGL_NO_CONTEXT, contextAttribs );
    
    if ( esContext->eglContext == EGL_NO_CONTEXT )
    {
        return GL_FALSE;
    }
    
    // Make the context current
    if ( !eglMakeCurrent ( esContext->eglDisplay, esContext->eglSurface,
                          esContext->eglSurface, esContext->eglContext ) )
    {
        return GL_FALSE;
    }
    
#endif // #ifndef __APPLE__
    
    return GL_TRUE;
}

void ESContext::init(){
    
    createWindow("OpenGL", _viewInfo.width, _viewInfo.height, ES_WINDOW_RGB);
    
    char vShaderScanConversion[] =
    "#version 300 es                                \n"
    "uniform mat4 Move;                             \n"
    "uniform mat4 Modelview;                        \n"
    "uniform mat4 Aspect;                           \n"
    "uniform mat4 MoveOffset;                       \n"
    "uniform float vValue;                          \n"
    "uniform float x1;                              \n"
    "uniform float x2;                              \n"
    "uniform float meshType; \n"
    "out float posX;    "
    "out vec2 vLateralEdge; "
    // Clipping하기 위해 필요함.
    "layout(location = 0) in vec2 a_position;       \n"
    "layout(location = 1) in vec3 a_texCoord;       \n"
    "out vec3 v_texCoord;                           \n"
    "out float oValue;                              \n"
    "void main()                                    \n"
    "{                                              \n"
    " v_texCoord = a_texCoord;                      \n"
    " oValue = vValue;                              \n"
    " vLateralEdge = vec2(x1, x2);"
    " posX = a_position.x;"
    " gl_Position = vec4(a_position, 0.0f, 1.0f) * Move *Aspect* Modelview;  \n"
    "}                                              \n";
    
    char fShaderScanConversion[] =
    "#version 300 es                                \n"
    "precision highp float;                         \n"
    "in vec3 v_texCoord;                            \n"
    "in float oValue;                               \n"
    "in vec2 vLateralEdge;                       "
    "in float posX; "
    "layout(location = 0) out vec4 outColor;        \n"
    "uniform sampler2D s_baseMap;                   \n"
    "void main()                                    \n"
    "{                                              \n"
    "   outColor = vec4(1.0, 1.0, 0.0, 1.0);        \n"
    "}                                              \n";
    
    switch (esVersion) {
        case 3:
            _programObject =  esLoadProgram(vShaderScanConversion, fShaderScanConversion);
            break;
            
        default:
            abort();    // 미지원
            break;
    }
    
    _baseMapLoc = glGetUniformLocation ( _programObject, "s_baseMap" );
    _depth = 8; // default depth;
}

void ESContext::initWithViewsize(int width, int height){
    _viewInfo.width  = width;
    _viewInfo.height = height;
    
    init();
}

void ESContext::draw(){
    
    float yOffset = 0;
    float vertices[20] = {0}; //{x, y, u, v}
    
    if (_indices == NULL) {
        _indices = (GLushort *)malloc(sizeof(short) * kTotalVertexCount);
    }
    
    for (int i=0; i<kTotalVertexCount; ++i) {
        _indices[i] = i;
    }
    
    glUseProgram(_programObject);
    
    // Set the viewport
    glViewport ( 0, 0, _viewInfo.width, _viewInfo.height);
    
    // Clear the color buffer
    glClearColor ( 0.0f, 0.0f, 0.0f, 1.0f );
    glClear ( GL_COLOR_BUFFER_BIT );
    
    vertices[0] = -0.5;
    vertices[1] = 0.5 + yOffset;

    vertices[5] = 0.5;
    vertices[6] = 0.5 + yOffset;

    vertices[10] = -0.5;
    vertices[11] = -0.5 + yOffset;

    vertices[15] = 0.5;
    vertices[16] = -0.5 + yOffset;
    
    for (int i=0; i<4; ++i) {
        vertices[i * 5+2] = 1.0;
        vertices[i * 5+3] = 1;
        vertices[i * 5+4] = 1;
    }
    
    glBlendFunc(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
    
    glEnableVertexAttribArray(0);
    glEnableVertexAttribArray(1);

    glVertexAttribPointer(0, 2, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), vertices);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 5*sizeof(GLfloat), &vertices[2]);
    glDrawElements(GL_TRIANGLE_STRIP, 4, GL_UNSIGNED_SHORT, _indices);

    glDisableVertexAttribArray(0);
    glDisableVertexAttribArray(1);
    
}

void ESContext::update(GLfloat timeDelta){
    float defaultHeight = 341.0f;   // 물리적인 높이. 현재 기준: scan co
    float viewHeight = 512.0f;      // view size

    float totalHeight = (defaultHeight/_depth)*_probeHead.radius + defaultHeight;    // 삼각 호의 총 높이. (r+depth)

    double height = (defaultHeight/viewHeight)*2;
    float topRate = _probeHead.radius/(_probeHead.radius+_depth);
    float verticalCenter = (_depth/2.0f)/(_probeHead.radius+_depth);
    float off =  topRate*height + verticalCenter*height;
    _offsetY = off;
    
    float sz = totalHeight/(defaultHeight) * _viewInfo.scale;
    float ratio = (float)_viewInfo.width / (float)_viewInfo.height;   // 가로/세로비
    
    float aspect[16]={
        ratio, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1,
    };
    
    float move[16]={
        1, 0, 0, 0,
        0, 1, 0, 0,//off,
        0, 0, 1, 0,
        0, 0, 0, 1
    };
    
    float scale[16]={
        (sz), 0, 0, 0,
        0, sz, 0, 0,
        0, 0, sz, 0,
        0, 0, 0, 1
    };
    
    float moveOffset[16]={
        1, 0, 0, 0,
        0, 1, 0, 0,
        0, 0, 1, 0,
        0, 0, 0, 1
    };

//    // Rotation Y
//    float rotateMatrix[16] = {
//        cosf(rotateDelta), 0, sinf(rotateDelta), 0,
//        0, 1, 0, 0,
//        -sinf(rotateDelta), 0, cosf(rotateDelta), 0,
//        0, 0, 0, 1
//    };
    
    GLint aspectUniform = glGetUniformLocation(_programObject, "Aspect");
    glUniformMatrix4fv(aspectUniform, 1, 0, aspect);
    
    GLint moveUniform = glGetUniformLocation(_programObject, "Move");
    glUniformMatrix4fv(moveUniform, 1, 0, move);
    
    GLint modelviewUniform = glGetUniformLocation(_programObject, "Modelview");
    glUniformMatrix4fv(modelviewUniform, 1, 0, scale);
    
    GLint moveOffsetUniform = glGetUniformLocation(_programObject, "MoveOffset");
    glUniformMatrix4fv(moveOffsetUniform, 1, 0, moveOffset);
    
}

GLuint ESContext::loadTexture(GLubyte *buf, int width, int height){
    GLuint texId = 0;
    
    if (buf == NULL) {
        esLogMessage("Errlr loading Texture");
        return 0;
    }
    
    glGenTextures ( 1, &texId );
    glBindTexture ( GL_TEXTURE_2D, texId );
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, buf );
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    return texId;
}

GLuint ESContext::loadRGBTexture(GLubyte *buf, int width, int height){
    GLuint texId = 0;
    
    if (buf == NULL) {
        esLogMessage("Errlr loading Texture");
        return 0;
    }
    
    glGenTextures ( 1, &texId );
    glBindTexture ( GL_TEXTURE_2D, texId );
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_RGBA, width, height, 0, GL_RGBA, GL_UNSIGNED_BYTE, buf );
    
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    return texId;
}

bool ESContext::updateTexture(GLubyte *buffer, int width, int height){
    
    if (buffer == NULL) {
        return false;
    }
    
    if (_textureId > 0) {
        glDeleteTextures(GL_TEXTURE_2D, &_textureId);
        _textureId = NULL;
    }
    
    GLuint texId;
    
    // rotate 180'
    if (_rBuf == NULL) {
        _rBuf = (unsigned char *) malloc(width*height);
    }
    
    // CW
    for (int y =0; y<height; ++y) {
        for (int x=0; x<width; ++x) {
            // Color RGB
            unsigned int targetIndex = (y*width)+x;
            unsigned int getIndex = height*(width-1-x)+y;
            unsigned char value = buffer[getIndex];
            
            if (targetIndex<width) {
                value = 0x00;
            }
            _rBuf[targetIndex] = value;
        }
    }
    
    if (_indices == NULL) {
        _indices = (GLushort *)malloc(sizeof(short)*kTotalVertexCount);
    }
    
    for (int i=0; i<kTotalVertexCount; ++i) {
        _indices[i] = i;
    }
    
    glGenTextures ( 1, &texId );
    glBindTexture ( GL_TEXTURE_2D, texId );
    glTexImage2D ( GL_TEXTURE_2D, 0, GL_LUMINANCE, width, height, 0, GL_LUMINANCE, GL_UNSIGNED_BYTE, _rBuf );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_LINEAR );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE );
    glTexParameteri ( GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE );
    
    _textureId = texId;
    return texId != 0;
}

void ESContext::createVeritices(GLfloat **buffer, ProbeHead head, GLuint depth){
    // Set Veritices
    if (*buffer == NULL) {
        *buffer = (GLfloat *)malloc(sizeof(GLfloat) * kTotalVertexCount*5);
    }
    
    switch (head.headType) {
        case ProbeHeadTypeLinear:
            createVeriticesRect(buffer, head, depth);
            break;
        case ProbeHeadTypeConvex:
        case ProbeHeadTypeMicroConvex:
        case ProbeHeadTypePhasedArray:
            createVeriticesArc(buffer, head, depth);
            break;
        default:
            break;
    }
}

void ESContext::createVeriticesArc(GLfloat **buffer, ProbeHead head, GLuint depth){
    GLfloat *buf = *buffer;
    GLuint totalVertexCount = kTotalVertexCount;
    
    double pi = M_PI * _probeHead.fieldOfView / 180.0f;
    double defaultTheta = (M_PI-pi)/2.0f;
    double dtheta = pi / SLICE_COUNT;
    float unit = 1.0f/(SLICE_COUNT);
    
    float defaultHeight = 341.0f;   // 물리적인 높이. 현재 기준: scan co
    float viewHeight = 512.0f;    // view size
    float radius =  (defaultHeight/viewHeight)*2;
    
    
    float preUnit = unit;
    float afterTexSize = 1-unit;
    unit = afterTexSize/(128);
    afterTexSize+=preUnit/2;
    
    float vUnit = 1.0/512;
    float tempVertical = 1-vUnit;
    vUnit = tempVertical/511;
    
    for (int i=0; i<(totalVertexCount/2); ++i) {
        float theta =dtheta*i;
        // Top Points
        // vertex (x, y)
        buf[i*10]   = (i-(128/2)) * 0.0001;
        buf[i*10+1] = 0.0f;
        
        // texture(x, y, z)
        buf[i*10+2] = afterTexSize;
        buf[i*10+3] = -(_probeHead.radius/_depth);
        buf[i*10+4] = 1;
        
        // Under Points
        // vertex (x, y)
        buf[i*10+5] = -(radius * cosf(defaultTheta+theta));
        buf[i*10+6] = -(radius * sinf(defaultTheta+theta));
        
        // texture(x, y, z)
        buf[i*10+7] = afterTexSize;
        buf[i*10+8] = 1;
        buf[i*10+9] = 1;
        
        // Adjust texture coordinate
        if (i>0)
        {
            // right_top - left_bottom
            float ax = (buf[GET_INDEX(2)])  - (buf[GET_INDEX(1)]);
            float ay = (buf[GET_INDEX(2)+1])- (buf[GET_INDEX(1)+1]);
            // left top - right_bottom
            float bx = (buf[GET_INDEX(0)])  - (buf[GET_INDEX(3)]);
            float by = (buf[GET_INDEX(0)+1])- (buf[GET_INDEX(3)+1]);
            
            float cross = ax * by - ay * bx;
            
            if (cross != 0) {
                // left_bottom - right_bottom;
                float cx = (buf[GET_INDEX(1)]) - (buf[GET_INDEX(3)]);
                float cy = (buf[GET_INDEX(1)+1]) - (buf[GET_INDEX(3)+1]);
                
                float s = (ax * cy - ay * cx) / cross;
                
                if (s > 0 && s < 1) {
                    float t = (bx * cy - by * cx) / cross;
                    
                    if (t > 0 && t < 1) {
                        //uv coordinates for texture
                        float u0 = afterTexSize; // texture bottom left u
                        float u2 = afterTexSize - (i*unit); // texture top right u
                        
                        float q0 = 1 / (1 - t);
                        float q1 = 1 / (1 - s);
                        float q2 = 1 / t;
                        float q3 = 1 / s;
                        
                        if (i==1) {
                            buf[GET_INDEX(0)+2] = u0 * q3;
                            buf[GET_INDEX(0)+4] = q3;
                            
                            buf[GET_INDEX(1)+2] = u0 * q0;
                            buf[GET_INDEX(1)+4] = q0;
                        }
                        buf[GET_INDEX(3)+2] = u2 * q1;
                        buf[GET_INDEX(3)+4] = q1;
                        
                        buf[GET_INDEX(2)+2] = u2 * q2;
                        buf[GET_INDEX(2)+4] = q2;
                    }
                }
            }
        }
    }
}

void ESContext::createVeriticesRect(GLfloat **buffer, ProbeHead head, GLuint depth){
    
    GLfloat *buf = *buffer;
    GLuint totalVertexCount = kTotalVertexCount;

    float ratio = head.footPrint / depth;
    float unit = 1.0f/SLICE_COUNT;
    
    float viewHeight = 512.0f;      // view size
    float defaultHeight = 341.0f;   // 물리적인 높이. 현재 기준: scan co
    float radius =  (defaultHeight/viewHeight)*2;
    
    float diameter = radius * ratio;
    
    for (int i=0; i<(totalVertexCount/2); ++i) {
        float theta =diameter * i*unit;
        // Top Points
        // vertex (x, y)
        buf[i*10] = theta -  diameter/2;
        buf[i*10+1]  =0.0f;
        
        // texture(x, y, z)
        buf[i*10+2] = 1-i*unit;
        buf[i*10+3] = 0;
        buf[i*10+4] = 1;
        
        // Under Points
        // vertex (x, y)
        buf[i*10+5] = theta -  diameter/2;
        buf[i*10+6] = -radius;
        
        // texture(x, y, z)
        buf[i*10+7] = 1-i*unit;
        buf[i*10+8] = 1.0f;
        buf[i*10+9] = 1;
    }
}

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
#include "CommonHeader.h"
#else
#include <GLES3/gl3.h>
#include <EGL/egl.h>
#include <EGL/eglext.h>
#endif

typedef struct {
    int width = 320, height = 320;
    float scale = 1.0;
} ViewInfo;

class ESContext {
    ProbeHead _probeHead;
    ViewInfo _viewInfo;
    
    GLuint _programObject;
    GLuint _textureId;
    GLint _baseMapLoc;
    
    GLfloat *_vVertices;    // B Image frame
    GLushort *_indices;
    GLubyte *_rBuf;         // rBuf: BMode nBuf: Doppler
    bool _textureUpdated;
    bool _isRotate;
    float _rotateDelta;
    float _offsetY;
    
    void init();
    
    /**
     윈도우를 생성한다.

     @param title 윈도우 제목
     @param width 윈도우 가로 크기
     @param height 윈도우 세로 크기
     @param flags 플래그
     @return 성공여부
     */
    bool createWindow(const char *title, GLint width, GLint height, GLint flags);
    
    /**
     버텍스 버퍼를 형성한다.

     @param buffer 버텍스 버퍼 포인터
     @param head 프로브 헤드 정보
     @param depth 깊이
     */
    void createVeritices(GLfloat **buffer, ProbeHead head, GLuint depth);
    
    /**
     호(Arc) 형태의 버텍스 버퍼를 형성한다.

     @param buffer 버텍스 버퍼 포인터
     @param head 프로브 헤드 정보
     @param depth 깊이
     */
    void createVeriticesArc(GLfloat **buffer, ProbeHead head, GLuint depth);
    
    /**
     사각형 형태의 버텍스 버퍼를 형성한다.
     
     @param buffer 버텍스 버퍼 포인터
     @param head 프로브 헤드 정보
     @param depth 깊이
     */
    void createVeriticesRect(GLfloat **buffer, ProbeHead head, GLuint depth);
    
    /**
     흑백(Grayscale)텍스처를 생성한다.

     @param buf 텍스처 이미지 버퍼
     @param width 이미지 가로 크기
     @param height 이미지 세로 크기
     @return 텍스처 아이디
     */
    GLuint loadTexture(GLubyte *buf, int width, int height);
    
    /**
     컬러(RGBA) 텍스처를 생성한다.

     @param buf 텍스처 이미지 버퍼
     @param width 이미지 가로 크기
     @param height 이미지 세로 크기
     @return 텍스처 아이디
     */
    GLuint loadRGBTexture(GLubyte *buf, int width, int height);
    
public:
    GLuint _depth;
    int esVersion;
    
    ESContext();
    virtual ~ESContext();
    
    /**
     뷰 사이즈와 함께 초기화시킨다.

     @param width 가로 뷰 사이즈
     @param height 세로 뷰 사이즈
     */
    void initWithViewsize(int width, int height);
    /**
     렌더링 루프
     */
    void draw();
    
    /**
     US이미지 렌더링
     */
    void drawUSImage();
    
    /**
     업데이트 프로세서

     @param timeDelta 마지막 업데이트로부터 경과시간.
     */
    void update(GLfloat timeDelta);
    
    /**
     프로브 정보를 설정한다.
     
     @param probe 프로브 정보 구조체
     */
    void setProbeInfo(ProbeHead probe);
    
    /**
     이미지를 회전시킨다.
     
     @param isRotate 회전 여부
     */
    void setRotate(bool isRotate);
    
    /**
     텍스쳐를 업데이트한다.

     @param buffer 텍스처 데이터
     @param width 텍스처 데이터 가로 사이즈
     @param height 텍스처 데이터 세로 사이즈
     @return 텍스처 생성 성공 여부
     */
    bool updateTexture(GLubyte *buffer, int width, int height);
};

#endif /* defined(__GLViewModule__esContext__) */

//
//  GLView.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "GLView.h"
#import "esContext.h"

#define FPS 30

@interface GLView()
@property (strong, nonatomic) NSTimer *renderingTimer;
@property (assign) ESContext *esContext;
@property (strong) NSDate *lastUpdate;
@end

@implementation GLView

- (void)setup {
    // 3.0 부터 순차적으로 시도.
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    self.context = [[EAGLContext alloc] initWithAPI:api];
    
    // 실패할 경우 지원되지 않는다는 메시지를 띄운다.
    if (!self.context) {
        NSString *errorMessage = NSLocalizedString(@"Unsupported device!\nHave to support OpenGL ES 3.0 or later", nil);
        [self showErrorMessage:errorMessage];
        return;
    }
    
    // GL 셋업
    [self initESContextWithGLESVersion:api];
    
    // 렌더링 타이머 셋업
    self.renderingTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/FPS target:self selector:@selector(rendering) userInfo:nil repeats:true];
}

/**
 스캔 데이터를 업데이트한다.
 
 @param data 로우 포맷 데이터
 @param size 로우 포맷 이미지 사이즈
 */
- (void)updateScanData:(NSData *)data withSize:(CGSize)size {
    _esContext->updateTexture((unsigned char *)data.bytes, size.width, size.height);
}

/**
 메모리를 강제로 해제한다.
 */
- (void)readyToRelease {
    [self.renderingTimer invalidate];
    self.renderingTimer = nil;
    self.lastUpdate = nil;
    self.esContext->~ESContext();
    free(self.esContext);
    self.esContext = nil;
}

- (void)initESContextWithGLESVersion:(EAGLRenderingAPI)api {
    
    [EAGLContext setCurrentContext:self.context];
    self.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    self.drawableMultisample = GLKViewDrawableMultisample4X;
    
    if (!_esContext) {
        self.esContext = new ESContext;
        self.esContext->esVersion = api;
        
        CGSize viewsize = self.frame.size;
        float scale = [[UIScreen mainScreen] nativeScale];
        self.esContext->initWithViewsize(viewsize.width * scale, viewsize.height * scale);
    }
}

- (NSTimeInterval)timeSinceLastUpdate {
    if (!self.lastUpdate) return 0;
    return [[NSDate date] timeIntervalSinceDate:self.lastUpdate];
}

- (void)rendering {
    [self update];
    [self setNeedsDisplay];
}

- (void)update {
    _esContext->update([self timeSinceLastUpdate]);
    self.lastUpdate = [NSDate date];
}

- (void)drawRect:(CGRect)rect {
    _esContext->draw();
}


/**
 에러메시지를 출력한다.
 
 @param message 메시지 내용
 */
- (void)showErrorMessage:(NSString *)message {
    UILabel *lbeError = [self viewWithTag:9999];
    if (!lbeError) {
        lbeError = [[UILabel alloc] initWithFrame:self.frame];
        lbeError.tag           = 9999;
        lbeError.alpha         = 0.8;
        lbeError.textColor     = [UIColor whiteColor];
        lbeError.numberOfLines = 0;
        lbeError.textAlignment = NSTextAlignmentCenter;
        [self addSubview:lbeError];
    }
    
    lbeError.text = message;
}
@end

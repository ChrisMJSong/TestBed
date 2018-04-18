//
//  GLView.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>
#import "CommonHeader.h"

@interface GLView : GLKView

- (void)setup;

/**
 에러메시지를 출력한다.

 @param message 메시지 내용
 */
- (void)showErrorMessage:(NSString *)message;

/**
 스캔 데이터를 업데이트한다.

 @param data 로우 포맷 데이터
 */
- (void)updateScanData:(NSData *)data withSize:(CGSize)size;

/**
 프로브 정보를 설정한다.

 @param probeInfo 프로브 정보 구조체
 */
- (void)setProbeHeadInfo:(ProbeHead)probeInfo;

/**
 깊이를 설정한다.

 @param depth 깊이값
 */
- (void)setDepth:(NSInteger)depth;

/**
 메모리를 강제로 해제한다.
 */
- (void)readyToRelease;

/**
 이미지를 Y축으로 회전시킨다.
 */
- (void)toggleRotate:(BOOL)isRotate;
@end

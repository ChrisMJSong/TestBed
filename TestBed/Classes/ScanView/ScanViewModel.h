//
//  ScanViewModel.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonHeader.h"

typedef enum{
    ScanViewModeStream      = 0,
    ScanViewModeViewerImage
} ScanViewMode;

@class ImageItem;

@protocol ScanViewModelDelegate
/**
 로우 데이터를 전송한다.

 @param data 로우 포맷 데이터
 @param size 로우 포맷 이미지 크기
 */
- (void)didReceiveRawData:(NSData *)data withSize:(CGSize)size;

/**
 프레임 정보를 전송한다.

 @param depth <#depth description#>
 */
- (void)didReceiveFrameInfo:(NSNumber *)depth;

/**
 프로브 헤드 정보를 전송한다.

 @param probeInfo 프로브 헤드 구조체
 */
- (void)didReceiveProbeHeadInfo:(ProbeHead)probeInfo;

/**
 뷰 모드를 묻는다.
 
 @return 뷰 모드
 */
- (ScanViewMode)askViewMode;

/**
 이미지 아이템을 얻어온다.
 
 @return 이미지 아이템
 */
- (ImageItem *)imageItem;
@end

@interface ScanViewModel : NSObject
@property (assign, nonatomic) id<ScanViewModelDelegate> delegate;

- (void)setup;
@end

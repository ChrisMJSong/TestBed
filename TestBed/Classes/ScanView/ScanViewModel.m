//
//  ScanViewModel.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ScanViewModel.h"
#import "ImageItem.h"

#define TEST_FPS    15

@interface ScanViewModel()
@property (strong, nonatomic) NSTimer *streamReceiver;
@property (strong, nonatomic) ImageItem *imageItem;
@end

@implementation ScanViewModel

- (void)setup{
    ScanViewMode mode = [self.delegate askViewMode];
    
    ImageItem *item = nil;
    
    switch (mode) {
        case ScanViewModeStream:
            
            // 데이터 셋업
             self.imageItem = [ImageItem streamingItem];
            
            // 스트리밍 시작
            _streamReceiver = [NSTimer scheduledTimerWithTimeInterval:1.0/TEST_FPS target:self selector:@selector(loadNextImage) userInfo:nil repeats:true];
            break;
            
        case ScanViewModeViewerImage:
        {
            // 이미지 로드
            item = [self.delegate imageItem];
            NSData *firstImage = [item frameDataAtIndex:0];
            // NOTE: Raw데이터의 크기는 1024 x 128 고정이다.
            [self.delegate didReceiveRawData:firstImage withSize:CGSizeMake(128, 1024)];
            NSNumber *fristInfo = [item frameInfoAtIndex:0];
            [self.delegate didReceiveFrameInfo:fristInfo];
            break;
        }
    }
    
    // 공통
    ProbeHead probe = [item probeInfo];
    [self.delegate didReceiveProbeHeadInfo:probe];
}

- (void)loadNextImage{
    
}
@end

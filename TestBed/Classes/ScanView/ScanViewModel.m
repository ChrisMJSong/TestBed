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
    switch (mode) {
        case ScanViewModeStream:
            
            // 데이터 셋업
             self.imageItem = [ImageItem streamingItem];
            
            // 스트리밍 시작
            _streamReceiver = [NSTimer scheduledTimerWithTimeInterval:1.0/TEST_FPS target:self selector:@selector(loadNextImage) userInfo:nil repeats:true];
            break;
            
        case ScanViewModeViewerImage:
            break;
    }
}

- (void)loadNextImage{
    
}
@end

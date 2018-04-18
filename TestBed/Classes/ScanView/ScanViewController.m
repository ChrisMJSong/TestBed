//
//  ScanViewController.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ScanViewController.h"
#import "ScanViewModel.h"
#import "GLView.h"
#import "ImageItem.h"
#import "SideRulerView.h"

@interface ScanViewController ()<UIScrollViewDelegate, ScanViewModelDelegate, SideRulerViewDelegate>
@property (strong, nonatomic) ScanViewModel *viewModel;
@property (weak, nonatomic) IBOutlet GLView *glView;
@property (weak, nonatomic) IBOutlet SideRulerView *sideRulerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (assign) BOOL isInit;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self setup];
}

- (void)dealloc {
    [self.glView readyToRelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 뷰가 로드 된 이후 설정
 */
- (void)setup {
    // 초기화는 1회만 실시함.
    if (self.isInit) {
        return;
    }
    
    // opengl 설정
    [self.glView setup];
    
    [self.sideRulerView setup];
    self.sideRulerView.delegate = self;
    
    // load file
    self.viewModel = [[ScanViewModel alloc] init];
    self.viewModel.delegate = self;
    [self.viewModel setup];
    
    self.isInit = true;
}

- (IBAction)modalClose:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}


#pragma mark - ScanViewModelDelegate
/**
 로우 데이터를 전송한다.
 
 @param data 로우 포맷 데이터
 @param size 로우 포맷 이미지 크기
 */
- (void)didReceiveRawData:(NSData *)data withSize:(CGSize)size{
    // 받은 데이터를 업데이트한다.
    [self.glView updateScanData:data withSize:size];
}

- (void)didReceiveFrameInfo:(NSNumber *)depth {
    [self.glView setDepth:depth.integerValue];
    [self.sideRulerView changeDepth:depth.floatValue];
}

- (void)didReceiveProbeHeadInfo:(ProbeHead)probeInfo {
    // 프로브 정보를 설정한다.
    [self.sideRulerView setMinDepth:probeInfo.minDepth withMaxDepth:probeInfo.maxDepth];
    [self.glView setProbeHeadInfo:probeInfo];
}

/**
 뷰 모드를 묻는다.
 
 @return 뷰 모드를 얻어온다.
 */
- (ScanViewMode)askViewMode{
    return self.viewMode;
}

#pragma mark - SideRulerViewDelegate
- (void)didChangeDepth:(float)depth {
    [self.glView setDepth:(NSInteger)depth];
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.glView;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self.sideRulerView changeScale:scrollView.zoomScale];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.sideRulerView changeContentOffset:scrollView.contentOffset];
}
@end

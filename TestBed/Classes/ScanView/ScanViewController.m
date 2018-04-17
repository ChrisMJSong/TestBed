//
//  ScanViewController.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ScanViewController.h"
#import "GLView.h"
#import "SideRulerView.h"

@interface ScanViewController ()<UIScrollViewDelegate, ScanViewModelDelegate>
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
    [self.sideRulerView changeDepth:4];
    
    self.isInit = true;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

/**
 뷰 모드를 묻는다.
 
 @return 뷰 모드를 얻어온다.
 */
- (ScanViewMode)askViewMode{
    return self.viewMode;
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

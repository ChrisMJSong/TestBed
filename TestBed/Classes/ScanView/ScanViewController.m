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

@interface ScanViewController ()
@property (weak, nonatomic) IBOutlet GLView *glView;
@property (weak, nonatomic) IBOutlet SideRulerView *sideRulerView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

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
    // opengl 설정
    [self.glView setup];
    
    [self.sideRulerView setup];
    [self.sideRulerView changeDepth:4];
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
@end

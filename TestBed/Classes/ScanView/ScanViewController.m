//
//  ScanViewController.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ScanViewController.h"
#import "GLView.h"

@interface ScanViewController ()
@property (weak, nonatomic) IBOutlet GLView *glView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated {
    [self.glView setup];
}

- (void)dealloc {
    [self.glView readyToRelease];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

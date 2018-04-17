//
//  GLViewModel.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "GLViewModel.h"
#import "GLView.h"

@interface GLViewModel ()

@property (strong, nonatomic) EAGLContext *context;
@end

@implementation GLViewModel


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES3;
    self.context = [[EAGLContext alloc] initWithAPI:api];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (GLView *)glView {
    return (GLView *)self.view;
}

- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    [[self glView] draw];
}

- (void)update {
    NSLog(@"update from glkview");
}

@end

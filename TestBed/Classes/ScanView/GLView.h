//
//  GLView.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GLKit/GLKit.h>

@interface GLView : GLKView

- (void)setup;

/**
 에러메시지를 출력한다.

 @param message 메시지 내용
 */
- (void)showErrorMessage:(NSString *)message;

- (void)readyToRelease;
@end

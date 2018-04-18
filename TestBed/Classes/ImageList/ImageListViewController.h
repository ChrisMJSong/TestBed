//
//  ImageListViewController.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageListViewController : UIViewController
/**
 최초 설정을 한다.
 */
- (void)setup;

/**
 한 줄에 갖는 아이템 갯수를 돌려준다.

 @return 아이템 갯수
 */
- (float)itemPerRow;
@end

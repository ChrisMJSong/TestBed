//
//  SideRulerView.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SideRulerView : UIView
- (void)setup;
- (void)changeDepth:(float)depth;
- (void)changeScale:(float)scale;
- (void)changeContentOffset:(CGPoint)contentOffset;
@end

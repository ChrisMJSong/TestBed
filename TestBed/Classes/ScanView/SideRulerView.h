//
//  SideRulerView.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SideRulerViewDelegate
- (void)didChangeDepth:(float)depth;
@end

@interface SideRulerView : UIView
@property (assign, nonatomic) id<SideRulerViewDelegate> delegate;

/**
 초기설정
 */
- (void)setup;

/**
 깊이를 변경한다.
 
 @param depth 목표 깊이
 */
- (void)changeDepth:(float)depth;

/**
 스케일을 변경한다.

 @param scale 목표 스케일
 */
- (void)changeScale:(float)scale;

/**
 사이드룰러의 오프셋을 설정함.

 @param contentOffset 사이드룰러 오프셋
 */
- (void)changeContentOffset:(CGPoint)contentOffset;

/**
 최대, 최소 깊이를 설정함.
 
 @param minDepth 최소 깊이
 @param maxDepth 최대 깊이
 */
- (void)setMinDepth:(float)minDepth withMaxDepth:(float)maxDepth;
@end

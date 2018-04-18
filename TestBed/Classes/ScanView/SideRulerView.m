//
//  SideRulerView.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "SideRulerView.h"
#import "CommonHeader.h"

#define OFFSET_X_START      40.0f
#define RULLER_WIDTH_BIG    20.0f
#define RULLER_WIDTH_MID    10.0f
#define RULLER_WIDTH_SMALL   5.0f
#define LINE_WIDTH           1.0f
#define TEXT_SIZE           10.0f

#define LINE_COLOR      [UIColor whiteColor]
#define TEXT_COLOR      [UIColor whiteColor]
#define CUSOR_COLOR     [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.3f]
#define RULLER_LENGTH   (self.originalSize.height  *  (PHYSICAL_HEIGHT / TARGET_VIEW_HEIGHT))
#define PANNING_LENGTH  (IS_PHONE?40:60)
#define IS_PHONE        ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define kPixelPerCentimeter (IS_PHONE?64.8f:52.6f)

@interface SideRulerView()
@property float depth;
@property float minDepth;
@property float maxDepth;
@property float scale;
@property CGSize originalSize;
@property float contentOffsetY;
@property float panStartPointY;

/**
 패닝을 통해 깊이를 조절한다.
 
 @param gesture 팬제스쳐 인스턴스
 */
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture;
@end

@implementation SideRulerView

- (id)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // 팬 제스쳐 추가
        UIPanGestureRecognizer* panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureAction:)];
        panGesture.minimumNumberOfTouches = 1;
        panGesture.maximumNumberOfTouches = 1;
        [self addGestureRecognizer:panGesture];
        
        self.minDepth = 2;
        self.maxDepth = 8;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* lineColor = LINE_COLOR;
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, LINE_WIDTH);
    
    float length = RULLER_LENGTH;
    float topMargin = ((self.originalSize.height - length) / 2) - self.contentOffsetY / self.scale;
    float totalHeight = length*self.scale;
    float offsetY = totalHeight / self.depth;
    
    // 세로 기준선
    CGContextMoveToPoint(context, OFFSET_X_START+RULLER_WIDTH_BIG, topMargin  * self.scale);
    CGContextAddLineToPoint(context, OFFSET_X_START+RULLER_WIDTH_BIG, topMargin * self.scale + totalHeight);
    
    float minimumUnit = offsetY/5;
    
    for (int i=0; i<=self.depth; ++i) {
        float ptY = (offsetY * i)  + topMargin * self.scale;
        CGContextMoveToPoint(context, OFFSET_X_START,ptY); //start at this point
        
        if (i%5==0) {
            CGContextMoveToPoint(context, OFFSET_X_START, ptY);
        }else{
            CGContextMoveToPoint(context, OFFSET_X_START+8, ptY);
        }
        
        CGContextAddLineToPoint(context, OFFSET_X_START+RULLER_WIDTH_BIG, ptY); //여기까지 그림
        
        // cm표기
        if (i == self.depth) {
            UIFont* font = [UIFont systemFontOfSize:TEXT_SIZE];
            UIColor* textColor = TEXT_COLOR;
            
            NSDictionary* stringAttrs = @{ NSFontAttributeName : font, NSForegroundColorAttributeName : textColor };
            
            NSAttributedString* attrStr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d%@", i, (i==self.depth?@" cm": @"")] attributes:stringAttrs];
            
            [attrStr drawAtPoint:CGPointMake(OFFSET_X_START-30, ptY-TEXT_SIZE-2)];
        }
        
        if (i == self.depth) {
            break;
        }
        
        
        if (offsetY >= kPixelPerCentimeter) {
            for (int j=1 ; j<5; ++j) {
                CGContextMoveToPoint(context, OFFSET_X_START+(RULLER_WIDTH_BIG-RULLER_WIDTH_SMALL), ptY+minimumUnit*j);
                CGContextAddLineToPoint(context, OFFSET_X_START+(RULLER_WIDTH_BIG-RULLER_WIDTH_SMALL)+RULLER_WIDTH_SMALL, ptY+minimumUnit*j);
            }
        }
    }
    
    // 그리기
    CGContextStrokePath(context);
    CGContextFillPath(context);
}

/**
 패닝을 통해 깊이를 조절한다.

 @param gesture 팬제스쳐 인스턴스
 */
- (void)panGestureAction:(UIPanGestureRecognizer *)gesture {
    
    CGPoint touchPoint = [gesture locationInView:self];
    CGPoint velocity = [gesture velocityInView:self];
    
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan:
            self.panStartPointY = touchPoint.y;
            break;
            
        case UIGestureRecognizerStateChanged:
            if (abs((int)(self.panStartPointY - touchPoint.y)) > PANNING_LENGTH) {
                self.panStartPointY = touchPoint.y;
                
                if (velocity.y > 0) {
                    // 아래로 패닝
                    if (self.depth > self.minDepth) {
                        --self.depth;
                    }
                }else{
                    // 위로 패닝
                    if (self.depth < self.maxDepth) {
                        ++self.depth;
                    }
                }
                
                [self.delegate didChangeDepth:self.depth];
            }
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        default:
            break;
    }
    
    [self setNeedsDisplay];
}

/**
 초기설정
 */
- (void)setup {
    self.depth = 8;
    self.scale = 1;
    self.originalSize = self.bounds.size;
    [self setNeedsDisplay];
}

/**
 깊이를 변경한다.
 
 @param depth 목표 깊이
 */
- (void)changeDepth:(float)depth {
    self.depth = depth;
    [self setNeedsDisplay];
}

/**
 스케일을 변경한다.
 
 @param scale 목표 스케일
 */
- (void)changeScale:(float)scale {
    self.scale = scale;
    [self setNeedsDisplay];
}

/**
 사이드룰러의 오프셋을 설정함.
 
 @param contentOffset 사이드룰러 오프셋
 */
- (void)changeContentOffset:(CGPoint)contentOffset {
    // y값만 필요함.
    self.contentOffsetY = contentOffset.y;
    
    [self setNeedsDisplay];
}

/**
 최대, 최소 깊이를 설정함.

 @param minDepth 최소 깊이
 @param maxDepth 최대 깊이
 */
- (void)setMinDepth:(float)minDepth withMaxDepth:(float)maxDepth{
    self.minDepth = minDepth;
    self.maxDepth = maxDepth;
}

@end

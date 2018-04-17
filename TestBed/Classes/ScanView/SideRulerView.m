//
//  SideRulerView.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "SideRulerView.h"

#define OFFSET_X_START      40.0f
#define RULLER_WIDTH_BIG    20.0f
#define RULLER_WIDTH_MID    10.0f
#define RULLER_WIDTH_SMALL   5.0f
#define LINE_WIDTH           1.0f
#define TEXT_SIZE           10.0f

#define LINE_COLOR      [UIColor whiteColor]
#define TEXT_COLOR      [UIColor whiteColor]
#define CUSOR_COLOR     [UIColor colorWithRed:0.8f green:0.8f blue:0.8f alpha:0.3f]
#define RULLER_LENGTH   (self.originalSize.height  *  (341.0 / 512))
#define PANNING_LENGTH  (IS_PHONE?40:60)
#define IS_PHONE        ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define kPixelPerCentimeter (IS_PHONE?64.8f:52.6f)

@interface SideRulerView()
@property float depth;
@property float scale;
@property CGSize originalSize;
@end

@implementation SideRulerView

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor* lineColor = LINE_COLOR;
    CGContextSetStrokeColorWithColor(context, lineColor.CGColor);
    CGContextSetLineWidth(context, LINE_WIDTH);
    
    float length = RULLER_LENGTH;
    float topMargin = (self.originalSize.height - length) / 2;
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

- (void)setup {
    self.depth = 8;
    self.scale = 1;
    self.originalSize = self.bounds.size;
    [self setNeedsDisplay];
}

- (void)changeDepth:(float)depth {
    self.depth = depth;
}

- (void)changeScale:(float)scale {
    self.scale = scale;
}

@end

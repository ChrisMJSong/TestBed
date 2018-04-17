//
//  ImageItem.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ImageItem.h"

@implementation ImageItem

- (NSArray *)imageFramePaths {
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"bs" inDirectory:self.fileName];
}
@end

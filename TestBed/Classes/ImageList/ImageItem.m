//
//  ImageItem.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ImageItem.h"

#define STREAM_DUMMY    @"stream"

@interface ImageItem()
@property (strong) NSMutableArray *frameDatas;
@end

@implementation ImageItem

+ (ImageItem *)streamingItem {
    // 스트리밍 더미 아이템을 반환한다.
    ImageItem *item = [[ImageItem alloc] init];
    item.filePath = STREAM_DUMMY;
    [item loadFrameDatas];
    
    return item;
}

- (NSArray *)imageFramePaths {
    return [[NSBundle mainBundle] pathsForResourcesOfType:@"bs" inDirectory:self.fileName];
}

- (void)loadFrameDatas{
    NSArray *pathes = [self imageFramePaths];
    if (!self.frameDatas) {
        self.frameDatas = [[NSMutableArray alloc] init];
    }
    [self.frameDatas removeAllObjects];
    
    for (NSString *pathString in pathes) {
        // load from local
        NSString *path = [NSURL fileURLWithPath:pathString];
        NSData *raw = [NSData dataWithContentsOfURL:path];
        [self.frameDatas addObject:raw];
    }
}

- (void)unloadFrameDatas{
    [self.frameDatas removeAllObjects];
}

- (NSData *)frameDataAtIndex:(NSInteger)index{
    return self.frameDatas[index];
}
@end

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
@property (strong) NSMutableArray *frameInfos;
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

- (NSData *)dataForResourcesOfType:(NSString *)extionsionName {
    NSArray *paths = [[NSBundle mainBundle] pathsForResourcesOfType:extionsionName inDirectory:self.fileName];
    NSString *pathString = paths.lastObject;
    if (!pathString) {
        return nil;
    }
    NSURL *path = [NSURL fileURLWithPath:pathString];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:pathString]) {
        // 파일을 찾을 수 없다면 널을 리턴함.
        return nil;
    }
    
    return [NSData dataWithContentsOfURL:path];
}

- (void)loadFrameDatas{
    NSArray *pathes = [self imageFramePaths];
    if (!self.frameDatas) {
        self.frameDatas = [[NSMutableArray alloc] init];
    }
    [self.frameDatas removeAllObjects];
    
    for (NSString *pathString in pathes) {
        // load from local
        NSURL *path = [NSURL fileURLWithPath:pathString];
        NSData *raw = [NSData dataWithContentsOfURL:path];
        [self.frameDatas addObject:raw];
    }
}

- (void)loadFrameInfos {
    if (!self.frameInfos) {
        self.frameInfos = [[NSMutableArray alloc] init];
    }
    NSData *stringData = [self dataForResourcesOfType:@"txt"];
    NSString *infoText = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
    
    // NOTE: 테스트용이기 때문에 데이터 위치값을 고정함.
    NSArray *strs = [infoText componentsSeparatedByString:@"\n"];
    
    for (int i=11; i<strs.count; ++i) {
        NSArray *lineString = [strs[i] componentsSeparatedByString:@"\t"];
        if (lineString.count > 1) {
            NSString *depthString = lineString[1];
//            NSString *focalString = lineString[2];
            [self.frameInfos addObject:@(depthString.integerValue)];
        }else{
            break;
        }
    }
}

/**
 프레임 데이터를 불러온다.
 */
- (void)unloadFrameDatas{
    [self.frameDatas removeAllObjects];
    self.frameDatas = nil;
}

/**
 프레임 데이터의 메모리를 해제한다.
 */
- (void)unloadFrameInfos{
    [self.frameInfos removeAllObjects];
    self.frameInfos = nil;
}

/**
 프로브 정보를 돌려준다.
 
 @return 프로브 정보 구조체
 */
- (ProbeHead)probeInfo {
    if (!self.probeHead.headType) {
        ProbeHead newProbe;
        
        NSData *stringData = [self dataForResourcesOfType:@"txt"];
        NSString *infoText = [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
        
        // NOTE: 테스트용이기 때문에 데이터 위치값을 고정함.
        NSArray *strs = [infoText componentsSeparatedByString:@"\n"];
        NSString *headTypeString = [strs[4] componentsSeparatedByString:@"\t"][1];
        
        if ([headTypeString isEqualToString:@"Convex"]) {
            newProbe.headType = ProbeHeadTypeConvex;
            newProbe.radius         = 6.0;
            newProbe.fieldOfView    = 58.2125;
            newProbe.footPrint      = 6.0;
            newProbe.minDepth       = 4;
            newProbe.maxDepth       = 20;
        }else if ([headTypeString isEqualToString:@"Linear"]) {
            newProbe.headType = ProbeHeadTypeLinear;
            newProbe.radius         = 0;
            newProbe.fieldOfView    = 0;
            newProbe.footPrint      = 3.84;
            newProbe.minDepth       = 2;
            newProbe.maxDepth       = 10;
        }else {
            newProbe.headType = ProbeHeadTypeUnknown;
        }
        
        self.probeHead = newProbe;
    }
    return self.probeHead;
}

/**
 미리보기 이미지를 반환한다.
 
 @return 이미지 인스턴스
 */
- (UIImage *)thumbnailImage {
    NSData *imageData = [self dataForResourcesOfType:@"jpg"];
    
    return [UIImage imageWithData:imageData];
}

/**
 해당 인덱스의 프레임 정보를 반환한다.
 
 @param index 인덱스
 @return 프레임 정보 (뎁스)
 */
- (NSNumber *)frameInfoAtIndex:(NSInteger)index{
    if (self.frameInfos.count == 0) {
        [self loadFrameInfos];
    }
    return self.frameInfos[index];
}

/**
 해당 인덱스의 프레임 데이터를 반환한다.
 
 @param index 인덱스
 @return 프레임 데이터
 */
- (NSData *)frameDataAtIndex:(NSInteger)index{
    if (self.frameDatas.count == 0) {
        [self loadFrameDatas];
    }
    return self.frameDatas[index];
}
@end

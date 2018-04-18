//
//  ImageItem.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonHeader.h"

@interface ImageItem : NSObject

@property (strong) NSString *fileName;
@property (strong) NSString *filePath;
@property (assign) ProbeHead probeHead;

+ (ImageItem *)streamingItem;

- (void)loadFrameDatas;
- (void)unloadFrameDatas;
- (ProbeHead)probeInfo;
- (NSNumber *)frameInfoAtIndex:(NSInteger)index;
- (NSData *)frameDataAtIndex:(NSInteger)index;
@end

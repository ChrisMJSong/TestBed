//
//  ImageItem.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageItem : NSObject

@property (strong) NSString *fileName;
@property (strong) NSString *filePath;

+ (ImageItem *)streamingItem;

- (void)loadFrameDatas;
- (void)unloadFrameDatas;
- (NSData *)frameDataAtIndex:(NSInteger)index;
@end

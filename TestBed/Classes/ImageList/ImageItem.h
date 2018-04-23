//
//  ImageItem.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CommonHeader.h"

@interface ImageItem : NSObject

@property (strong) NSString *fileName;
@property (strong) NSString *filePath;
@property (assign) ProbeHead probeHead;

+ (ImageItem *)streamingItem;

/**
 프레임 데이터를 불러온다.
 */
- (void)loadFrameDatas;

/**
 프레임 데이터의 메모리를 해제한다.
 */
- (void)unloadFrameDatas;

/**
 프로브 정보를 돌려준다.

 @return 프로브 정보 구조체
 */
- (ProbeHead)probeInfo;

/**
 미리보기 이미지를 반환한다.

 @return 이미지 인스턴스
 */
- (UIImage *)thumbnailImage;

/**
 해당 인덱스의 프레임 정보를 반환한다.

 @param index 인덱스
 @return 프레임 정보 (뎁스)
 */
- (NSNumber *)frameInfoAtIndex:(NSInteger)index;

/**
 해당 인덱스의 프레임 데이터를 반환한다.

 @param index 인덱스
 @return 프레임 데이터
 */
- (NSData *)frameDataAtIndex:(NSInteger)index;
@end

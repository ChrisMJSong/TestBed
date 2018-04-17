//
//  ImageListViewModel.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageItem.h"

@interface ImageListViewModel : NSObject
/**
 이미지 리스트 뷰 설정을 한다.
 */
- (void)setup;

/**
 테스트 아이템을 셋업한다.
 */
- (void)testItemSetup;

// MARK: 아이템 콘트롤 관련 함수
/**
 인덱스에 해당하는 아이템을 가져온다.

 @param index 인덱스 번호
 @return 아이템 인스턴스
 */
- (ImageItem *)itemAt:(NSInteger)index;

/**
 아이템을 추가한다.

 @param item 아이템 인스턴스
 */
- (void)addItem:(ImageItem *)item;

/**
 해당 인덱스에 아이템을 추가한다.

 @param item 아이템 인스턴스
 @param index 추가할 인덱스 위치
 */
- (void)insertItem:(ImageItem *)item at:(NSInteger)index;

/**
 해당 인덱스의 아이템을 삭제한다.

 @param index 아이템 인스턴스
 */
- (void)removeItemAt:(NSInteger)index;

/**
 아이템을 삭제한다.

 @param item 아이템 인스턴스
 */
- (void)removeItem:(ImageItem *)item;

/**
 아이템 인덱스를 반환한다.

 @param item 아이템
 @return 아이템 인덱스
 */
- (NSInteger)indexOf:(ImageItem *)item;

@end

//
//  ImageListViewModel.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ImageListViewModel.h"

@interface ImageListViewModel()
@property (strong, nonatomic) NSMutableArray *items;
@end

@implementation ImageListViewModel
/**
 이미지 리스트 뷰 설정을 한다.
 */
- (void)setup {
    self.items = [[NSMutableArray alloc] init];
    
    // MARK: 테스트 데이터
    [self testItemSetup];
}

/**
 테스트 아이템을 셋업한다.
 */
- (void)testItemSetup {
    NSArray *fileNames = @[@"test01", @"test02"];
    
    for (NSString *filename in fileNames) {
        ImageItem *item = [[ImageItem alloc] init];
        item.fileName = filename;
        [self addItem:item];
    }
}

// MARK: 아이템 콘트롤 관련 함수
/**
 인덱스에 해당하는 아이템을 가져온다.
 
 @param index 인덱스 번호
 @return 아이템 인스턴스
 */
- (ImageItem *)itemAt:(NSInteger)index{
    return [_items objectAtIndex:index];
}

/**
 아이템을 추가한다.
 
 @param item 아이템 인스턴스
 */
- (void)addItem:(ImageItem *)item {
    [_items addObject:item];
}

/**
 해당 인덱스에 아이템을 추가한다.
 
 @param item 아이템 인스턴스
 @param index 추가할 인덱스 위치
 */
- (void)insertItem:(ImageItem *)item at:(NSInteger)index {
    [_items insertObject:item atIndex:index];
}

/**
 해당 인덱스의 아이템을 삭제한다.
 
 @param index 아이템 인스턴스
 */
- (void)removeItemAt:(NSInteger)index {
    [_items removeObjectAtIndex:index];
};

/**
 아이템을 삭제한다.
 
 @param item 아이템 인스턴스
 */
- (void)removeItem:(ImageItem *)item {
    [_items removeObject:item];
}

/**
 아이템 인덱스를 반환한다.
 
 @param item 아이템
 @return 아이템 인덱스
 */
- (NSInteger)indexOf:(ImageItem *)item {
    return [_items indexOfObject:item];
}


#pragma - UICollectionViewDelegate Function
/**
 섹션의 개수를 반환한다.
 
 @return 섹션 개수
 */
- (NSInteger)numberOfSection {
    return 1;
}
/**
 섹션의 아이템 개수를 반환한다.
 
 @return 아이템 개수
 */
- (NSInteger)numberOfItemsInSection {
    return _items.count;
}
@end

//
//  ImageListCollectionViewCell.h
//  TestBed
//
//  Created by Chris Song on 18/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImageItem;

@interface ImageListCollectionViewCell : UICollectionViewCell
/**
 아이템을 셀에 적용한다.

 @param item 아이템 인스턴스
 */
- (void)updateItem:(ImageItem *)item;
@end

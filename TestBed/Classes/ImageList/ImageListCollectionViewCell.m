//
//  ImageListCollectionViewCell.m
//  TestBed
//
//  Created by Chris Song on 18/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ImageListCollectionViewCell.h"
#import "ImageItem.h"

@interface ImageListCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageListCollectionViewCell
/**
 아이템을 셀에 적용한다.
 
 @param item 아이템 인스턴스
 */
- (void)updateItem:(ImageItem *)item {
    self.imageView.image = [item thumbnailImage];
}
@end

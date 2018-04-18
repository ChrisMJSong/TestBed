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
- (void)updateItem:(ImageItem *)item;
@end

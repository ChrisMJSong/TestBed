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
- (void)updateItem:(ImageItem *)item {
    self.imageView.image = [item thumbnailImage];
}
@end

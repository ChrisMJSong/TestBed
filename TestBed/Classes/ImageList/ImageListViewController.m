//
//  ImageListViewController.m
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ImageListViewController.h"
#import "ImageListViewModel.h"
#import "ScanViewController.h"
#import "ImageListCollectionViewCell.h"

@interface ImageListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) ImageListViewModel *viewModel;
@end

@implementation ImageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:false animated:false];
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:true animated:false];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"SegueScan"]) {
        UINavigationController *navi = segue.destinationViewController;
        ScanViewController *viewController = navi.viewControllers.lastObject;
        
        viewController.viewMode = ScanViewModeViewerImage;
        viewController.imageItem = sender;
    }
}

/**
 최초 설정을 한다.
 */
- (void)setup {
    _viewModel = [[ImageListViewModel alloc] init];
    [_viewModel setup];
}

/**
 한 줄에 갖는 아이템 갯수를 돌려준다.
 
 @return 아이템 갯수
 */
- (float)itemPerRow {
    float itemPerRow = 4;
    
    UIInterfaceOrientation deviceOrient = [[UIApplication sharedApplication] statusBarOrientation];
    UIUserInterfaceIdiom device = [[UIDevice currentDevice] userInterfaceIdiom];
    
    switch (deviceOrient) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
            
            switch (device) {
                case UIUserInterfaceIdiomPhone:
                    itemPerRow = 2;
                    break;
                    
                case UIUserInterfaceIdiomPad:
                    itemPerRow = 4;
                    break;
                default:
                    break;
            }
            
            break;
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
            switch (device) {
                case UIUserInterfaceIdiomPhone:
                    itemPerRow = 4;
                    break;
                    
                case UIUserInterfaceIdiomPad:
                    itemPerRow = 7;
                    break;
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    
    return itemPerRow;
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    UICollectionViewLayout *layout = self.collectionView.collectionViewLayout;
    [layout invalidateLayout];
}


#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageItem *item = [self.viewModel itemAt:indexPath.row];
    [self performSegueWithIdentifier:@"SegueScan" sender:item];
}

- (UICollectionReusableView *) collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return nil;
}


#pragma mark - UICollectionViewDataSource
- (NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _viewModel.numberOfSection;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _viewModel.numberOfItemsInSection;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"ImageCell";
    ImageListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    ImageItem *item = [self.viewModel itemAt:indexPath.row];
    [cell updateItem:item];
    return cell;
}


#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    float cellPadding = [self itemPerRow] * 2 - 2;
    float itemWidth = (collectionView.frame.size.width - cellPadding) / [self itemPerRow];
    
    return CGSizeMake(itemWidth, itemWidth);
}

@end

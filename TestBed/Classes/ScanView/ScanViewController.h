//
//  ScanViewController.h
//  TestBed
//
//  Created by Chris Song on 17/04/2018.
//  Copyright © 2018 Chris Song. All rights reserved.
//

#import "ScanViewModel.h"

@class ImageItem;

@interface ScanViewController : UIViewController

@property (assign) ScanViewMode viewMode;
@property (assign) ImageItem *imageItem;
- (IBAction)modalClose:(id)sender;

@end

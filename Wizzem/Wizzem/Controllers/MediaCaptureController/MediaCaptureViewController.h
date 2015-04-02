//
//  MediaCaptureViewController.h
//  Wizzem
//
//  Created by Remi Robert on 30/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizzMediaModel.h"

@interface MediaCaptureViewController : UIViewController

@property (nonatomic, strong) WizzMediaModel *currentMedia;

- (void)displayMedia;

@end

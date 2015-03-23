//
//  DetailMediaViewController.h
//  Wizzem
//
//  Created by Remi Robert on 22/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizzMedia.h"
#import "WizzMediaModel.h"

@interface DetailMediaViewController : UIViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) WizzMediaModel *mediaModel;

@end

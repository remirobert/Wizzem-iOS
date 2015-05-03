//
//  LocationPickerViewController.h
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationPickerViewController : UIViewController

@property (nonatomic, strong) void (^selectionBlock)(NSDictionary *location);

@end

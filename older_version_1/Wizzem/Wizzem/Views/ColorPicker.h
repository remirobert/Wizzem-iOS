//
//  ColorPicker.h
//  Wizzem
//
//  Created by Remi Robert on 18/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColorPicker : UIView

@property (nonatomic, strong) void (^blockSelection)(UIColor *colorSelected);

@end

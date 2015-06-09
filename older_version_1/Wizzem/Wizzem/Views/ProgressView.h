//
//  ProgressView.h
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressView : UIView

+ (void)show:(UIView *)parentView withTitle:(NSString *)title;
+ (void)hide;

@end

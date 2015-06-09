//
//  ShimmerView.h
//  Wizzem
//
//  Created by Remi Robert on 11/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShimmerView : UIView

@property (nonatomic, strong, setter=setText:) NSString *text;
@property (nonatomic, strong, setter=setTextColor:) UIColor *textColor;

@end

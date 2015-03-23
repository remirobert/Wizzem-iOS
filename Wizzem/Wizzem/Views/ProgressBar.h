//
//  ProgressBar.h
//  Wizzem
//
//  Created by Remi Robert on 23/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressBar : UIView

@property (nonatomic, assign) NSInteger maxValue;

- (void)setProgress:(CGFloat)value;
- (instancetype)initWithFrame:(CGRect)frame;

@end

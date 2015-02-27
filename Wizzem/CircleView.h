//
//  CircleView.h
//  Wizzem
//
//  Created by Remi Robert on 27/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleView : UIView

@property(nonatomic) UIColor *strokeColor;

- (void)setStrokeEnd:(CGFloat)strokeEnd animated:(BOOL)animated;

@end

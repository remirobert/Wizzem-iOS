//
//  ProgressBar.m
//  Wizzem
//
//  Created by Remi Robert on 23/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ProgressBar.h"

@interface ProgressBar()
@property (nonatomic, strong) UIView *cursor;
@end

@implementation ProgressBar

- (UIView *)cursor {
    if (!_cursor) {
        _cursor = [[UIView alloc] initWithFrame:CGRectZero];
        _cursor.backgroundColor = [UIColor grayColor];
        CGRect frame = _cursor.frame;
        frame.size.height = self.frame.size.height;
    }
    return _cursor;
}

- (void)setProgress:(CGFloat)value {
    CGFloat newValue = self.maxValue * value / 100;
    
    [UIView animateWithDuration:1 delay:0.5 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        CGRect frame = self.cursor.frame;
        frame.size.width = newValue;
        self.cursor.frame = frame;

    } completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

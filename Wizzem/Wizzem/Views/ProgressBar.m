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
        _cursor.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.6];
        CGRect frame = _cursor.frame;
        frame.size.height = self.frame.size.height;
    }
    return _cursor;
}

- (void)setProgress:(CGFloat)value {
    CGFloat minValue = self.frame.size.width / self.maxValue;
    CGFloat newValue = value * minValue;
    
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionTransitionNone animations:^{
        self.cursor.frame = CGRectMake(0, 0, newValue, self.frame.size.height);
    } completion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.cursor];
    }
    return self;
}

@end

//
//  ShimmerView.m
//  Wizzem
//
//  Created by Remi Robert on 11/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ShimmerView.h"
#import <FBShimmering.h>
#import <FBShimmeringView.h>

@interface ShimmerView()
@property (nonatomic, strong) FBShimmeringView *shimmeringView;
@property (nonatomic, strong) UILabel *label;
@end

@implementation ShimmerView

#pragma mark -
#pragma mark setter

- (void)setText:(NSString *)text {
    _label.text = text;
}

- (void)setTextColor:(UIColor *)textColor {
    _label.textColor = textColor;
}

#pragma mark -
#pragma mark getter

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont boldSystemFontOfSize:20];
    }
    return _label;
}

- (FBShimmeringView *)shimmeringView {
    if (!_shimmeringView) {
        _shimmeringView = [[FBShimmeringView alloc] init];
        _shimmeringView.shimmeringAnimationOpacity = 0.1;
        _shimmeringView.shimmeringSpeed = 300;
        _shimmeringView.shimmering = YES;
    }
    return _shimmeringView;
}

#pragma mark -
#pragma mark contructor

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.shimmeringView.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        self.label.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);;
        [self addSubview:self.shimmeringView];
        self.shimmeringView.contentView = self.label;
    }
    return self;
}

@end

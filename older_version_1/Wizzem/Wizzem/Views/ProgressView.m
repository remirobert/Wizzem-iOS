//
//  ProgressView.m
//  Wizzem
//
//  Created by Remi Robert on 01/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ProgressView.h"

@interface ProgressView()
@property (nonatomic, strong) UILabel *title;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIView *indicatorView;
@end

@implementation ProgressView

- (UILabel *)title {
    if (!_title) {
        _title = [UILabel new];
        _title.textAlignment = NSTextAlignmentCenter;
        _title.textColor = [UIColor lightGrayColor];
        _title.font = [UIFont boldSystemFontOfSize:18];
    }
    return _title;
}

- (UIView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [UIView new];
        _indicatorView.layer.cornerRadius = 5;
        _indicatorView.frame = CGRectMake(25, [UIScreen mainScreen].bounds.size.height / 2 - 50, [UIScreen mainScreen].bounds.size.width - 50, 100);
        _indicatorView.backgroundColor = [UIColor whiteColor];
        _title.frame = CGRectMake(5, 5, _indicatorView.frame.size.width - 10, 30);
        [_indicatorView addSubview:_title];
    }
    return _indicatorView;
}

+ (instancetype)instance {
    static ProgressView *progressView;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        progressView = [[ProgressView alloc] init];
        progressView.frame = [UIScreen mainScreen].bounds;
        progressView.backgroundColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.6];
        [progressView addSubview:progressView.indicatorView];
    });
    return progressView;
}

+ (void)show:(UIView *)parentView withTitle:(NSString *)title {
    ProgressView *progressView = [self instance];
    if (progressView.superview) {
        [progressView removeFromSuperview];
    }
    progressView.title.text = title;
    [parentView addSubview:progressView];
}

+ (void)hide {
    [(ProgressView *)[self instance] removeFromSuperview];
}

@end

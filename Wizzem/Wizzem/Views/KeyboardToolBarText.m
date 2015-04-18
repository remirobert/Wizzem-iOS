//
//  KeyboardToolBarText.m
//  Wizzem
//
//  Created by Remi Robert on 18/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "KeyboardToolBarText.h"

@implementation KeyboardToolBarText

#pragma mark -
#pragma mark Buttons 

#pragma mark create buttons

- (UIButton *)makeButtonWithImage:(NSString *)imageName {
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setImage:[[UIImage imageNamed:imageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
    newButton.backgroundColor = [UIColor clearColor];
    return newButton;
}

- (UIButton *)makeButtonWithSting:(NSString *)title {
    UIButton *newButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [newButton setTitle:title forState:UIControlStateNormal];
    newButton.backgroundColor = [UIColor clearColor];
    newButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    return newButton;
}

#pragma mark init buttons

- (UIButton *)textColor {
    if (!_textColor) {
        _textColor = [self makeButtonWithImage:@"text"];
        CGRect frameButton;
        frameButton.size = CGSizeMake(30, 30);
        frameButton.origin = CGPointMake(self.validateButton.frame.origin.x - 37.5, 7.5);
        _textColor.selected = false;
        _textColor.frame = frameButton;
    }
    return _textColor;
}

- (UIButton *)linkButton {
    if (!_linkButton) {
        _linkButton = [self makeButtonWithImage:@"textLink"];
        CGRect frameButton;
        frameButton.size = CGSizeMake(30, 30);
        frameButton.origin = CGPointMake(7.5, 7.5);
        _linkButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _linkButton.frame = frameButton;
    }
    return  _linkButton;
}

- (UIButton *)quoteButton {
    if (!_quoteButton) {
        _quoteButton = [self makeButtonWithImage:@"textQuote"];
        CGRect frameButton;
        frameButton.size = CGSizeMake(30, 30);
        frameButton.origin = CGPointMake(self.linkButton.frame.origin.x + self.linkButton.frame.size.width + 7.5, 7.5);
        _quoteButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _quoteButton.frame = frameButton;
    }
    return  _quoteButton;
}

- (UIButton *)validateButton {
    if (!_validateButton) {
        _validateButton = [self makeButtonWithImage:@"textCheck"];
        CGRect frameButton;
        frameButton.size = CGSizeMake(30, 30);
        frameButton.origin = CGPointMake(self.frame.size.width - 37.5, 7.5);        
        _validateButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _validateButton.frame = frameButton;
    }
    return _validateButton;
}

- (UIButton *)backgroundColorButton {
    if (!_backgroundColorButton) {
        _backgroundColorButton = [self makeButtonWithImage:@"textBackground"];
        CGRect frameButton;
        frameButton.size = CGSizeMake(30, 30);
        frameButton.origin = CGPointMake(self.textColor.frame.origin.x - 37.5, 7.5);
        _backgroundColorButton.selected = false;
        _backgroundColorButton.frame = frameButton;
    }
    return  _backgroundColorButton;
}

#pragma mark -
#pragma mark UIView cycle

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.linkButton];
    [self addSubview:self.quoteButton];
    [self addSubview:self.textColor];
    [self addSubview:self.backgroundColorButton];
    [self addSubview:self.validateButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
    }
    return self;
}

@end

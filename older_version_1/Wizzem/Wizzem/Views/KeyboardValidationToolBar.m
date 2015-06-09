//
//  KeyboardValidationToolBar.m
//  Wizzem
//
//  Created by Remi Robert on 18/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "KeyboardValidationToolBar.h"

@implementation KeyboardValidationToolBar

#pragma mark -
#pragma mark buttons

- (void)selectButton:(UIButton *)button {
    if (self.blockSelection) {
        self.blockSelection(button.tag);
    }
}

- (UIButton *)validateButton {
    if (!_validateButton) {
        _validateButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _validateButton.frame = CGRectMake(self.frame.size.width - 40, 57.5, 30, 30);
        [_validateButton setImage:[[UIImage imageNamed:@"textCheck"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _validateButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _validateButton.tag = 1;
        [_validateButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _validateButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelButton.frame = CGRectMake(10, 57.5, 30, 30);
        [_cancelButton setImage:[[UIImage imageNamed:@"textCancel"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _cancelButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _cancelButton.tag = 0;
        [_cancelButton addTarget:self action:@selector(selectButton:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

#pragma mark -
#pragma mark UItextField

- (UITextField *)textField {
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.frame = CGRectMake(5, 5, self.frame.size.width, 40);
        _textField.backgroundColor = [UIColor clearColor];
        _textField.textColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _textField.font = [UIFont boldSystemFontOfSize:18];
    }
    return _textField;
}

#pragma mark -
#pragma mark UIView cycle

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.textField];
    [self addSubview:self.cancelButton];
    [self addSubview:self.validateButton];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];

    if (self) {
        
    }
    return self;
}

@end

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
        _validateButton = [[UIButton alloc] initWithFrame:CGRectMake(self.frame.size.width - 70, 7.5, 60, 30)];
        [_validateButton setTitle:@"Valider" forState:UIControlStateNormal];
        _validateButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _validateButton.tag = 1;
    }
    return _validateButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 7.5, 60, 30)];
        [_cancelButton setTitle:@"Annuler" forState:UIControlStateNormal];
        _cancelButton.tintColor = [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1];
        _cancelButton.tag = 0;
    }
    return _cancelButton;
}

#pragma mark -
#pragma mark UIView cycle

- (void)drawRect:(CGRect)rect {
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

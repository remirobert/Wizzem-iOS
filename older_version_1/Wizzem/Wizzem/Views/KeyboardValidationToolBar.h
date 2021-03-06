//
//  KeyboardValidationToolBar.h
//  Wizzem
//
//  Created by Remi Robert on 18/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KeyboardValidationToolBar : UIView

@property (nonatomic, strong) UIButton *validateButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UITextField *textField;

@property (nonatomic, strong) void (^blockSelection)(NSInteger tag);

@end

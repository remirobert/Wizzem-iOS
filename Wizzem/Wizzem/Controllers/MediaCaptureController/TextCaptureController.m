//
//  TextCaptureController.m
//  Wizzem
//
//  Created by Remi Robert on 14/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "TextCaptureController.h"
#import "KeyboardToolBarText.h"
#import "ColorPicker.h"
#import "KeyboardValidationToolBar.h"

@interface TextCaptureController() <UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, strong) KeyboardToolBarText *toolBar;
@property (nonatomic, strong) ColorPicker *colorPickerText;
@property (nonatomic, strong) ColorPicker *colorPickerBackground;
@property (nonatomic, strong) KeyboardValidationToolBar *keyboardValidation;
@property (nonatomic, strong) UIButton *captureButton;

@property (nonatomic, assign) NSInteger currentKaybord;
@end

@implementation TextCaptureController

#pragma mark -
#pragma mark ToolBar event

- (void)endEditing {
    NSDictionary *contentText = @{@"text":self.textView.text, @"textColor":self.textView.textColor, @"backgroundColor":self.textView.backgroundColor};
    
    self.currentMedia = [[WizzMediaModel alloc] init:WizzMediaText genericObjectMedia:contentText];
    [self displayMedia];
}

- (void)addLink {
    if (!self.toolBar.linkButton.selected) {
        self.currentKaybord = 0;
        [self cleanToolBar];
        self.toolBar.linkButton.selected = true;
        self.keyboardValidation.textField.text = @"http://";
        [self.keyboardValidation.textField becomeFirstResponder];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.keyboardValidation.frame;
            frameColorPicker.origin.y = self.toolBar.frame.origin.y - 50;
            self.keyboardValidation.frame = frameColorPicker;
            self.textView.alpha = 0.5;
            
            CGRect frameToolBar = self.toolBar.frame;
            frameToolBar.origin.y += frameToolBar.size.height;
            self.toolBar.frame = frameToolBar;
            
        } completion:nil];
    }
    else {
        self.toolBar.linkButton.selected = false;
        [self.textView becomeFirstResponder];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.keyboardValidation.frame;
            frameColorPicker.origin.y = self.view.frame.size.height;
            self.keyboardValidation.frame = frameColorPicker;
            self.textView.alpha = 1;
            
            CGRect frameToolBar = self.toolBar.frame;
            frameToolBar.origin.y -= frameToolBar.size.height;
            self.toolBar.frame = frameToolBar;

            
        } completion:nil];
    }
}

- (void)addQuote {
    if (!self.toolBar.quoteButton.selected) {
        [self cleanToolBar];
        self.currentKaybord = 1;
        self.toolBar.quoteButton.selected = true;
        self.keyboardValidation.textField.placeholder = @"Ecrivez votre citation";
        self.keyboardValidation.textField.text = @"";
        [self.keyboardValidation.textField becomeFirstResponder];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.keyboardValidation.frame;
            frameColorPicker.origin.y = self.toolBar.frame.origin.y - 50;
            self.keyboardValidation.frame = frameColorPicker;
            self.textView.alpha = 0.5;
            
            CGRect frameToolBar = self.toolBar.frame;
            frameToolBar.origin.y += frameToolBar.size.height;
            self.toolBar.frame = frameToolBar;
            
        } completion:nil];
    }
    else {
        self.toolBar.quoteButton.selected = false;
        [self.textView becomeFirstResponder];
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.keyboardValidation.frame;
            frameColorPicker.origin.y = self.view.frame.size.height;
            self.keyboardValidation.frame = frameColorPicker;
            self.textView.alpha = 1;
            
            CGRect frameToolBar = self.toolBar.frame;
            frameToolBar.origin.y -= frameToolBar.size.height;
            self.toolBar.frame = frameToolBar;
            
            
        } completion:nil];
    }
}

- (void)cleanToolBar {
    self.colorPickerBackground.frame = CGRectMake(0, self.view.frame.size.height, self.colorPickerBackground.frame.size.width, self.colorPickerBackground.frame.size.height);
    self.colorPickerText.frame = CGRectMake(0, self.view.frame.size.height, self.colorPickerText.frame.size.width, self.colorPickerText.frame.size.height);
    self.keyboardValidation.frame = CGRectMake(0, self.view.frame.size.height, self.keyboardValidation.frame.size.width, self.keyboardValidation
                                               .frame.size.height);
    self.toolBar.linkButton.selected = false;
    self.toolBar.textColor.selected = false;
    self.toolBar.backgroundColorButton.selected = false;
    self.textView.alpha = 1;
}

- (void)displayColorPickerText {
    if (!self.toolBar.textColor.selected) {
        [self cleanToolBar];
        self.toolBar.textColor.selected = true;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.colorPickerText.frame;
            frameColorPicker.origin.y = self.toolBar.frame.origin.y - self.colorPickerText.frame.size.height;
            self.colorPickerText.frame = frameColorPicker;
            self.textView.alpha = 0.7;
        } completion:nil];
    }
    else {
        self.toolBar.textColor.selected = false;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.colorPickerText.frame;
            frameColorPicker.origin.y = self.view.frame.size.height;
            self.colorPickerText.frame = frameColorPicker;
            self.textView.alpha = 1;
        } completion:nil];
    }
}

- (void)displayColorBackgroundPicker {
    if (!self.toolBar.backgroundColorButton.selected) {
        [self cleanToolBar];
        self.toolBar.backgroundColorButton.selected = true;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.colorPickerBackground.frame;
            frameColorPicker.origin.y = self.toolBar.frame.origin.y - self.colorPickerBackground.frame.size.height;
            self.colorPickerBackground.frame = frameColorPicker;
            self.textView.alpha = 0.7;
        } completion:nil];
    }
    else {
        self.toolBar.backgroundColorButton.selected = false;
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
            CGRect frameColorPicker = self.colorPickerBackground.frame;
            frameColorPicker.origin.y = self.view.frame.size.height;
            self.colorPickerBackground.frame = frameColorPicker;
            self.textView.alpha = 1;
        } completion:nil];
    }
}

#pragma mark -
#pragma mark UItextView delegate

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange {
    NSLog(@"link clicked");
    return true;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"placeholder text here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
}

#pragma mark -
#pragma mark setter getter

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.width)];
        _textView.backgroundColor = [UIColor blackColor];
        _textView.font = [UIFont boldSystemFontOfSize:22];
        _textView.textAlignment = NSTextAlignmentCenter;
        _textView.dataDetectorTypes = UIDataDetectorTypeLink;
    }
    return _textView;
}

- (KeyboardValidationToolBar *)keyboardValidation {
    if (!_keyboardValidation) {
        _keyboardValidation = [[KeyboardValidationToolBar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 100)];
        _keyboardValidation.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    }
    return _keyboardValidation;
}

- (ColorPicker *)colorPickerBackground {
    if (!_colorPickerBackground) {
        _colorPickerBackground = [[ColorPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        _colorPickerBackground.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    }
    return _colorPickerBackground;
}

- (ColorPicker *)colorPickerText {
    if (!_colorPickerText) {
        _colorPickerText = [[ColorPicker alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 50)];
        _colorPickerText.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
    }
    return _colorPickerText;
}

- (KeyboardToolBarText *)toolBar {
    if (!_toolBar) {
        _toolBar = [[KeyboardToolBarText alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
        _toolBar.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
        
        [_toolBar.textColor addTarget:self action:@selector(displayColorPickerText) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar.backgroundColorButton addTarget:self action:@selector(displayColorBackgroundPicker) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar.linkButton addTarget:self action:@selector(addLink) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar.quoteButton addTarget:self action:@selector(addQuote) forControlEvents:UIControlEventTouchUpInside];
        [_toolBar.validateButton addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
    }
    return  _toolBar;
}

- (UIButton *)captureButton {
    if (!_captureButton) {
        _captureButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _captureButton.frame = CGRectMake(self.view.frame.size.width - 37.5, 7.5, 30, 30);
        [_captureButton setImage:[[UIImage imageNamed:@"check"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        _captureButton.tintColor = [UIColor colorWithRed:0.25 green:0.24 blue:0.3 alpha:1];
        [_captureButton addTarget:self action:@selector(endEditing) forControlEvents:UIControlEventTouchUpInside];
    }
    return _captureButton;
}

#pragma mark -
#pragma mark keyboard management

- (void)registerForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
}

- (void)unregisterForKeyboardNotifications {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    [self.view addSubview:self.toolBar];
    
    CGRect frameTextView = self.textView.frame;
    frameTextView.size.height = self.view.frame.size.height - kbSize.height - 64 - self.toolBar.frame.size.height;
    self.textView.frame = frameTextView;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.4 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        CGRect frameToolBar = self.toolBar.frame;
        frameToolBar.origin.y = self.view.frame.size.height - kbSize.height - self.toolBar.frame.size.height;
        self.toolBar.frame = frameToolBar;
    } completion:nil];
}

#pragma mark -
#pragma mark UiView cycle

- (void)blockCompletionView {
    
    __block KeyboardToolBarText *toolBar = self.toolBar;
    __weak typeof(self) weakSelf = self;
    
    self.colorPickerText.blockSelection = ^(UIColor *colorSelected) {
        toolBar.textColor.tintColor = colorSelected;
        weakSelf.textView.textColor = colorSelected;
        [weakSelf displayColorPickerText];
        NSLog(@"color : %@", colorSelected);
    };
    
    self.colorPickerBackground.blockSelection = ^(UIColor *colorSelected) {
        toolBar.backgroundColorButton.tintColor = colorSelected;
        weakSelf.textView.backgroundColor = colorSelected;
        [weakSelf displayColorBackgroundPicker];
        NSLog(@"color : %@", colorSelected);
    };
    
    self.keyboardValidation.blockSelection = ^(NSInteger tag) {
        
        if (self.currentKaybord == 0 && tag == 1 && ![self.keyboardValidation.textField.text isEqualToString:@"http://"]) {
            weakSelf.textView.text = [NSString stringWithFormat:@"%@ %@", weakSelf.textView.text, weakSelf.keyboardValidation.textField.text];
        }
        else if (self.currentKaybord == 1 && self.keyboardValidation.textField.text.length > 0) {
            weakSelf.textView.text = [NSString stringWithFormat:@"%@\n\"%@\"\n", weakSelf.textView.text, weakSelf.keyboardValidation.textField.text];
        }
        NSLog(@"detect event");
        if (self.currentKaybord == 0) {
            [weakSelf addLink];
        }
        else {
            [weakSelf addQuote];
        }
    };
}

- (void)viewDidDisappear:(BOOL)animated {
    [self unregisterForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [self registerForKeyboardNotifications];
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.text = @"Write something amazing here";
    self.textView.textColor = [UIColor colorWithRed:0.35 green:0.35 blue:0.83 alpha:1];
    [self.textView becomeFirstResponder];
    self.textView.frame = CGRectMake(0, 64, self.textView.frame.size.width, self.textView.frame.size.width);

    [self.view addSubview:self.colorPickerText];
    [self.view addSubview:self.colorPickerBackground];
    [self.view bringSubviewToFront:self.keyboardValidation];
    [self.view addSubview:self.keyboardValidation];
    
    [self blockCompletionView];
}

@end

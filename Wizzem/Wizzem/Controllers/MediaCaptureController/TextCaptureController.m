//
//  TextCaptureController.m
//  Wizzem
//
//  Created by Remi Robert on 14/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "TextCaptureController.h"

@interface TextCaptureController() <UITextViewDelegate>
@property (strong, nonatomic) UITextView *textView;
@property (nonatomic, strong) UIView *toolBar;
@property (nonatomic, strong) UIButton *captureButton;
@end

@implementation TextCaptureController

#pragma mark -
#pragma mark ToolBar event

- (void)addLink {
}

- (void)endEditing {
    
}

#pragma mark -
#pragma mark UItextView delegate

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
    }
    return _textView;
}

- (UIView *)toolBar {
    if (!_toolBar) {
        _toolBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 44)];
        _toolBar.backgroundColor = [UIColor colorWithRed:0.12 green:0.12 blue:0.15 alpha:1];
        
        UIButton *link = [[UIButton alloc] initWithFrame:CGRectMake(5, 10, 50, 24)];
        [link setTitle:@"Link" forState:UIControlStateNormal];
        link.backgroundColor = [UIColor clearColor];
        link.titleLabel.textAlignment = NSTextAlignmentCenter;
        [link setTitleColor:[UIColor colorWithRed:0.56 green:0.56 blue:0.58 alpha:1] forState:UIControlStateNormal];

        [_toolBar addSubview:self.captureButton];
        
        [_toolBar addSubview:link];
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
}

@end

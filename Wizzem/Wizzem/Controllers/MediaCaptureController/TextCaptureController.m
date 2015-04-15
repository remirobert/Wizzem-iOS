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
@end

@implementation TextCaptureController

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
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont boldSystemFontOfSize:22];
        _textView.textAlignment = NSTextAlignmentCenter;
    }
    return _textView;
}

#pragma mark -
#pragma mark UiView cycle

- (void)viewDidAppear:(BOOL)animated {
    [self.view addSubview:self.textView];
    self.textView.delegate = self;
    self.textView.text = @"Write something amazing here";
    self.textView.textColor = [UIColor colorWithRed:0.56 green:0.55 blue:0.62 alpha:1];
    [self.textView becomeFirstResponder];
    self.textView.frame = CGRectMake(0, 64, self.textView.frame.size.width, self.textView.frame.size.height);
    NSLog(@"did appear");
}

@end

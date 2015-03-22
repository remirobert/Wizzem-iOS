//
//  DropDown.m
//  spinnerView
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "DropDown.h"
#import "Colors.h"

@interface DropDown()
@property (nonatomic, strong) UIButton *dropDownButton;
@property (nonatomic, strong) UIScrollView *contentScrollView;
@property (nonatomic, strong) NSArray *elements;
@property (nonatomic, assign) BOOL isDisplayed;
@property (nonatomic, assign) CGRect initialFrame;
@property (nonatomic, assign) void(^blockClickbutton)(NSInteger index);
@property (nonatomic, assign) NSInteger currentSelectedElement;
@end

@implementation DropDown

#pragma mark -
#pragma mark Action dropdown

- (void)moveDropDown {
    UIView *parentView = [self superview];
    if (parentView) {
        [self loadContentMenu];
        CGFloat sizeBottom = parentView.frame.size.height - (self.frame.origin.y + self.frame.size.height);
        if (self.contentScrollView.contentSize.height < sizeBottom) {
            sizeBottom = self.contentScrollView.contentSize.height;
        }
        if (!self.isDisplayed) {
            [UIView animateWithDuration:1.2 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                CGRect frameView = self.frame;
                frameView.size.height += sizeBottom;
                self.frame = frameView;
                
                [self.contentScrollView setContentOffset:CGPointZero];
                CGRect frameScroll = self.contentScrollView.frame;
                frameScroll.size.height = sizeBottom;
                self.contentScrollView.frame = frameScroll;
                
                [parentView viewWithTag:5].alpha = 0.3;
                [parentView viewWithTag:6].alpha = 0.3;
                
            } completion:^(BOOL finished) {
                self.isDisplayed = true;
            }];
        }
        else {
            [UIView animateWithDuration:0.8 delay:0 usingSpringWithDamping:0.5 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                self.frame = self.initialFrame;
                
                CGRect frameScroll = self.contentScrollView.frame;
                frameScroll.size.height = 0;
                self.contentScrollView.frame = frameScroll;
                
                [parentView viewWithTag:5].alpha = 1;
                [parentView viewWithTag:6].alpha = 1;
                
            } completion:^(BOOL finished) {
                self.isDisplayed = false;
            }];
        }
    }
}

- (void)clickButtonDropDownMenu:(UIButton *)sender {
    self.blockClickbutton(sender.tag);
    [self moveDropDown];
    self.currentSelectedElement = sender.tag;
    [UIView animateWithDuration:0.3 animations:^{
        self.dropDownButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self.dropDownButton setTitle:[self.elements objectAtIndex:sender.tag] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.3 animations:^{
            self.dropDownButton.alpha = 1;
        }];
    }];
}

#pragma mark -
#pragma mark init

#pragma mark lazy init

- (void)loadContentMenu {
    for (UIView *currentSubView in self.contentScrollView.subviews) {
        [currentSubView removeFromSuperview];
    }
    CGFloat indexPositionY = 0;
    CGFloat colorGradient = 0.90;
    NSInteger currentIndex = 0;
    for (NSString *currentElement in self.elements) {
        if (currentIndex != self.currentSelectedElement) {
            UIButton *newButton = [[UIButton alloc] initWithFrame:CGRectMake(0, indexPositionY, self.frame.size.width, 70)];
            [newButton setTitle:currentElement forState:UIControlStateNormal];
            [_contentScrollView addSubview:newButton];
            [newButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            newButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
            newButton.tag = currentIndex;
            [newButton addTarget:self action:@selector(clickButtonDropDownMenu:) forControlEvents:UIControlEventTouchUpInside];
            newButton.backgroundColor = [UIColor colorWithRed:colorGradient green:colorGradient blue:colorGradient alpha:1];
            colorGradient -= 0.04;
            indexPositionY += 70;
        }
        currentIndex += 1;
    }
    _contentScrollView.contentSize = CGSizeMake(self.frame.size.width, indexPositionY);
}

- (UIScrollView *)contentScrollView {
    if (!_contentScrollView) {
        _contentScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
        _contentScrollView.showsVerticalScrollIndicator = true;
        CGRect frameScroll = _contentScrollView.frame;
        frameScroll.size.height = 0;
        frameScroll.origin.y = self.frame.size.height;
        _contentScrollView.frame = frameScroll;
        [self loadContentMenu];
    }
    return _contentScrollView;
}

- (UIButton *)dropDownButton {
    if (!_dropDownButton) {
        _dropDownButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.initialFrame.size.width, self.initialFrame.size.height)];
        [_dropDownButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _dropDownButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        [_dropDownButton addTarget:self action:@selector(moveDropDown) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dropDownButton;
}

#pragma mark constructor

- (instancetype)initWithFrame:(CGRect)frame contentMenu:(NSArray *)content blockClickButton:(void (^)(NSInteger index))block {
    self = [super initWithFrame:frame];
    
    if (self) {
//        UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *visualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        visualEffect.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//        [self addSubview:visualEffect];

        self.initialFrame = frame;
        self.isDisplayed = false;
        self.blockClickbutton = block;
        self.currentSelectedElement = 0;
        self.elements = content;
        [self.dropDownButton setTitle:[content firstObject] forState:UIControlStateNormal];
        [self addSubview:self.dropDownButton];
        [self addSubview:self.contentScrollView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark setData

- (void)setContentDropDown:(NSArray *)content {
    self.currentSelectedElement = 0;
    self.elements = content;
    [self.dropDownButton setTitle:[content firstObject] forState:UIControlStateNormal];
    [self loadContentMenu];
}

@end

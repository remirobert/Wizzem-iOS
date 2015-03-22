//
//  SliderCameraFunction.m
//  Wizzem
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SliderCameraFunction.h"
#import "Colors.h"

@interface SliderCameraFunction()
@property (nonatomic, assign) void (^blockSelection)(NSInteger index);
@end

@implementation SliderCameraFunction

- (UIButton *)createButton:(CGFloat)positionX {
    CGFloat sizeButton = self.frame.size.height - self.frame.size.height / 3;
    
    CGRect frameButton = CGRectMake([UIScreen mainScreen].bounds.size.width / 2 - sizeButton / 2 + positionX, self.frame.size.height - sizeButton - sizeButton / 2, sizeButton, sizeButton);
    
    frameButton.origin.y = self.frame.size.height - self.frame.size.height + (self.frame.size.height - sizeButton) / 2;
    
    UIButton *newButton = [[UIButton alloc] init];
    newButton.tag = 1;
    newButton.frame = frameButton;
    newButton.layer.cornerRadius = newButton.frame.size.width / 2;
    newButton.layer.borderWidth = 5;
    newButton.layer.borderColor = [[UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1] CGColor];
    newButton.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1];
    return newButton;
}

#pragma mark -
#pragma mark UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    self.blockSelection(currentIndex);
}

#pragma mark -
#pragma mark init

- (void)initSliderButtons {
    self.pagingEnabled = true;
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    self.buttons = [[NSMutableArray alloc] init];
    
    CGFloat indexPositionX = 0;
    for (int indexButton = 0; indexButton < 5; indexButton++) {
        UIButton *newButton = [self createButton:indexPositionX];
        [self.buttons addObject:newButton];
        [self addSubview:newButton];
        indexPositionX += self.frame.size.width;
    }
    self.contentSize = CGSizeMake(indexPositionX, self.frame.size.height);
}

- (instancetype)initWithFrame:(CGRect)frame blockSelectionButton:(void(^)(NSInteger))block {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.blockSelection = block;
        [self initSliderButtons];
    }
    return self;
}

@end

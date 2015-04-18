//
//  ColorPicker.m
//  Wizzem
//
//  Created by Remi Robert on 18/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ColorPicker.h"

@interface ColorPicker()
@property (nonatomic, strong) NSArray *colors;
@property (nonatomic, strong) UIScrollView *scrollColors;
@end

@implementation ColorPicker

- (void)selectColor:(UIButton *)button {
    if (self.blockSelection) {
        self.blockSelection(button.backgroundColor);
    }
}

- (UIScrollView *)scrollColors {
    if (!_scrollColors) {
        CGRect frameScroll;
        frameScroll.origin = CGPointZero;
        frameScroll.size = self.frame.size;
        
        _scrollColors = [[UIScrollView alloc] initWithFrame:frameScroll];
        _scrollColors.backgroundColor = [UIColor clearColor];
        
        
        NSInteger indexColorPosition = 0;
        for (UIColor *currentColor in self.colors) {
            CGRect frameColorView;
            frameColorView.size = CGSizeMake(self.frame.size.height, self.frame.size.height);
            frameColorView.origin = CGPointMake(indexColorPosition, 0);
            
            UIButton *currentViewColor = [[UIButton alloc] initWithFrame:frameColorView];
            currentViewColor.backgroundColor = currentColor;
            [currentViewColor addTarget:self action:@selector(selectColor:) forControlEvents:UIControlEventTouchUpInside];
            
            [_scrollColors addSubview:currentViewColor];
            indexColorPosition += self.frame.size.height;
        }
        _scrollColors.contentSize = CGSizeMake(indexColorPosition, self.frame.size.height);
    }
    return _scrollColors;
}

- (NSArray *)defaultColors {
    return @[[UIColor colorWithRed:0.99 green:0.36 blue:0.26 alpha:1],
             [UIColor colorWithRed:0.99 green:0.57 blue:0.15 alpha:1],
             [UIColor colorWithRed:1 green:0.85 blue:0.35 alpha:1],
             [UIColor colorWithRed:0.51 green:0.97 blue:0.44 alpha:1],
             [UIColor colorWithRed:0.35 green:0.91 blue:0.79 alpha:1],
             [UIColor colorWithRed:0.18 green:0.83 blue:0.98 alpha:1],
             [UIColor colorWithRed:0.76 green:0.31 blue:0.97 alpha:1],
             [UIColor colorWithRed:0.93 green:0.32 blue:0.71 alpha:1],
             [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1],
             [UIColor colorWithRed:0.85 green:0.86 blue:0.86 alpha:1]];
}

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.scrollColors];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        self.colors = [self defaultColors];
    }
    return self;
}

@end

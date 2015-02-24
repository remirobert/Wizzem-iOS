//
//  SliderButtonPhoto.m
//  Wizzem
//
//  Created by Remi Robert on 24/02/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "SliderButtonPhoto.h"

@interface SliderButtonPhoto()
@property (nonatomic, strong) NSMutableArray *sliderButtons;
@end

@implementation SliderButtonPhoto

- (UIButton *) buttonPhoto:(CGFloat)positionX {
    UIButton *buttonPhoto = [[UIButton alloc] initWithFrame:CGRectMake(positionX, 0, 100, 100)];
    [buttonPhoto setImage:[UIImage imageNamed:@"sliderPhoto"] forState:UIControlStateNormal];
    buttonPhoto.layer.masksToBounds = true;
    buttonPhoto.imageView.contentMode = UIViewContentModeScaleAspectFill;
    return buttonPhoto;
}

- (UIButton *) buttonGif:(CGFloat)positionX {
    UIButton *buttonGif = [[UIButton alloc] initWithFrame:CGRectMake(positionX, 0, 100, 100)];
    [buttonGif setImage:[UIImage imageNamed:@"sliderGif"] forState:UIControlStateNormal];
    buttonGif.layer.masksToBounds = true;
    buttonGif.imageView.contentMode = UIViewContentModeScaleToFill;
    return buttonGif;
}

- (void) initSliderUI {
    self.layer.cornerRadius = self.frame.size.width / 2;
    self.pagingEnabled = true;
    self.layer.masksToBounds = true;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    self.showsHorizontalScrollIndicator = false;
    self.delegate = self;
    
    [self addSubview:[self buttonPhoto:0]];
    [self addSubview:[self buttonGif:100]];
    self.contentSize = CGSizeMake(200, 0);
}

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    [self initSliderUI];
    return self;
}

#pragma mark - scrollView delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
}

@end

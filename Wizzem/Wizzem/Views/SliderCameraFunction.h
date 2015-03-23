//
//  SliderCameraFunction.h
//  Wizzem
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WizzMedia.h"

@interface SliderCameraFunction : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, strong) NSMutableArray *buttons;

- (instancetype)initWithFrame:(CGRect)frame blockSelectionButton:(void(^)(WizzMediaType mediaType))block;

@end

//
//  DropDown.h
//  spinnerView
//
//  Created by Remi Robert on 21/03/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DropDown : UIView

- (instancetype)initWithFrame:(CGRect)frame contentMenu:(NSArray *)content blockClickButton:(void (^)(NSInteger index))block;
- (void)setContentDropDown:(NSArray *)content;
- (void)setIndexDropDownMenu:(NSInteger)index;

@end

//
//  ShimmerView.m
//  Wizzem
//
//  Created by Remi Robert on 11/04/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import "ShimmerView.h"
#import <FBShimmering.h>
#import <FBShimmeringView.h>

@implementation ShimmerView

+ (UIView *)instance:(NSString *)text {
    FBShimmeringView *shimmeringView = [[FBShimmeringView alloc] init];
    
    UILabel *loadingLabel = [[UILabel alloc] initWithFrame:shimmeringView.bounds];
    loadingLabel.textAlignment = NSTextAlignmentCenter;
    loadingLabel.text = text;//NSLocalizedString(@"Shimmer", nil);
    shimmeringView.contentView = loadingLabel;
    
    // Start shimmering.
    shimmeringView.shimmering = YES;
    return shimmeringView;
}

@end

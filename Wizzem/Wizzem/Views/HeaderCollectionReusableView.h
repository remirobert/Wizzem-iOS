//
//  HeaderCollectionReusableView.h
//  Wizzem
//
//  Created by Remi Robert on 30/05/15.
//  Copyright (c) 2015 Remi Robert. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderCollectionReusableView : UICollectionReusableView
@property (strong, nonatomic) IBOutlet UILabel *dateWizz;
@property (strong, nonatomic) IBOutlet UILabel *titleWizz;
@property (strong, nonatomic) IBOutlet UILabel *creatorWizz;
@property (strong, nonatomic) IBOutlet UILabel *hourWizz;
@end

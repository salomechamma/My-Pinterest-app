//
//  PinCell.h
//  mypint
//
//  Created by Salome Chamma on 3/1/17.
//  Copyright © 2017 Salome Chamma. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PinCell : UICollectionViewCell
@property (nonatomic, strong, readonly) UIImageView *imageView;
@property (nonatomic, strong, readonly) UILabel *descriptionLabel;
@end


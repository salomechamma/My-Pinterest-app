//
//  PinCell.m
//  mypint
//
//  Created by Salome Chamma on 3/1/17.
//  Copyright © 2017 Salome Chamma. All rights reserved.
//

#import "PinCell.h"

@implementation PinCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.translatesAutoresizingMaskIntoConstraints = NO;
        _imageView.clipsToBounds = YES;
        _imageView.layer.cornerRadius = 10.0;
        
        _descriptionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _descriptionLabel.font = [UIFont systemFontOfSize:13.0];
        _descriptionLabel.numberOfLines = 0;
        _descriptionLabel.minimumScaleFactor = .7;
        _descriptionLabel.translatesAutoresizingMaskIntoConstraints = NO;
        
        [self.contentView addSubview:_imageView];
        [self.contentView addSubview:_descriptionLabel];
        
        NSDictionary *views = NSDictionaryOfVariableBindings(_imageView, _descriptionLabel);
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_imageView][_descriptionLabel(20)]|" options:NSLayoutFormatAlignAllRight|NSLayoutFormatAlignAllLeft metrics:nil views:views]];
        [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_imageView]|" options:0 metrics:nil views:views]];
    }
    return self;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    self.imageView.image = nil;
}

@end


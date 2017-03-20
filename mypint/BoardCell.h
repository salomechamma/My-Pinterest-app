//
//  BoardCell.h
//  mypint
//
//  Created by Salome Chamma on 3/1/17.
//  Copyright © 2017 Salome Chamma. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;
@class PDKBoard;

typedef void (^BoardCellActionBlock)();

@interface BoardCell : UITableViewCell
@property (nonatomic, strong) IBOutlet UIImageView *boardImageView;
@property (nonatomic, strong) IBOutlet UILabel *percentageLabel;
@property (nonatomic, strong) IBOutlet UILabel *boardNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *boardDescriptionLabel;


@property (nonatomic, copy) BoardCellActionBlock addPinFromURLBlock;
@property (nonatomic, copy) BoardCellActionBlock addPinFromImageBlock;

- (IBAction)addPinFromURL:(id)sender;
- (IBAction)addPinFromImage:(id)sender;

- (void)updateWithBoard:(PDKBoard *)board;

- (void)showSpinner:(BOOL)show withPercentage:(CGFloat)percentage;
- (void)enableButtons:(BOOL)doEnable;
@end

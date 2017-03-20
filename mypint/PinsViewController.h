//
//  PinsViewController.h
//  mypint
//
//  Created by Salome Chamma on 3/1/17.
//  Copyright © 2017 Salome Chamma. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
#import "PDKClient.h"

@class PDKBoard;

typedef void (^PinsViewControllerLoadBlock)(PDKClientSuccess succes, PDKClientFailure failure);

@interface PinsViewController : UIViewController
@property (nonatomic, copy) PinsViewControllerLoadBlock dataLoadingBlock;
- (instancetype)initWithBoard:(PDKBoard *)board;
@end


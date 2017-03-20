
//
//  ViewController.m
//  mypint
//
//  Created by Salome Chamma on 3/1/17.
//  Copyright © 2017 Salome Chamma. All rights reserved.
//

#import "ViewController.h"
#import "PDKBoard.h"
#import "BoardsViewController.h"
#import "PDKClient.h"
#import "PDKPin.h"
#import "PinsViewController.h"
#import "PDKResponseObject.h"
#import "PDKUser.h"

@interface ViewController ()
@property (nonatomic, strong) PDKUser *user;
@property (nonatomic, strong) UILabel *resultLabel;
@property (nonatomic, strong) UIButton *boardsButton;
@property (nonatomic, strong) UIButton *createBoardButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = NSLocalizedString(@"My Little Pint'app", nil);
    
    
    
    UIButton *authenticateButton = [UIButton buttonWithType:UIButtonTypeSystem];
    authenticateButton.translatesAutoresizingMaskIntoConstraints = NO;
    [authenticateButton setTitle:NSLocalizedString(@"Sign-in!", nil) forState:UIControlStateNormal];

    [authenticateButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:30.0]];
    [authenticateButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [authenticateButton addTarget:self action:@selector(authenticateButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:authenticateButton];
 

    
    self.boardsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.boardsButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.boardsButton setTitle:NSLocalizedString(@"View Boards!", nil) forState:UIControlStateNormal];
    [self.boardsButton addTarget:self action:@selector(boardsButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.boardsButton];
    [_boardsButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:30.0]];
    [_boardsButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.resultLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    self.resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.resultLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.resultLabel];
    
    
    self.createBoardButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.createBoardButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.createBoardButton setTitle:NSLocalizedString(@"Create your Board", nil) forState:UIControlStateNormal];
    [self.createBoardButton addTarget:self action:@selector(createBoardButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.createBoardButton];
    [_createBoardButton.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:30.0]];
    [_createBoardButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(authenticateButton,  _boardsButton, _createBoardButton, _resultLabel);
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-[authenticateButton]-|" options:0 metrics:nil views:views]];

    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(100)-[authenticateButton]-[_boardsButton]-[_createBoardButton]-[_resultLabel]" options:NSLayoutFormatAlignAllLeft | NSLayoutFormatAlignAllRight metrics:nil views:views]];
    [self updateButtonEnabledState];
    
    __weak ViewController *weakSelf = self;
    [[PDKClient sharedInstance] silentlyAuthenticatefromViewController:self
                                                           withSuccess:^(PDKResponseObject *responseObject) {
                                                               [weakSelf updateButtonEnabledState];
                                                           } andFailure:nil];
}


- (void)updateButtonEnabledState
{
   self.boardsButton.enabled = self.createBoardButton.enabled = [PDKClient sharedInstance].authorized;
}

- (void)authenticateButtonTapped:(UIButton *)button
{
    __weak ViewController *weakSelf = self;
    [[PDKClient sharedInstance] authenticateWithPermissions:@[PDKClientReadPublicPermissions,
                                                              PDKClientWritePublicPermissions,
                                                              PDKClientReadRelationshipsPermissions,
                                                              PDKClientWriteRelationshipsPermissions]
                                         fromViewController:self
                                                withSuccess:^(PDKResponseObject *responseObject)
     {
         weakSelf.user = [responseObject user];
         weakSelf.resultLabel.text = [NSString stringWithFormat:@"%@ authenticated!", weakSelf.user.firstName];
         [weakSelf updateButtonEnabledState];
     } andFailure:^(NSError *error) {
         weakSelf.resultLabel.text = @"authentication failed";
     }];
}

- (void)pinItButtonTapped:(UIButton *)button
{
    __weak ViewController *weakSelf = self;
    [PDKPin pinWithImageURL:[NSURL URLWithString:@"https://about.pinterest.com/sites/about/files/logo.jpg"]
                       link:[NSURL URLWithString:@"https://www.pinterest.com"]
         suggestedBoardName:@"Tooty McFruity"
                       note:@"The Pinterest Logo"
         fromViewController:self
                withSuccess:^
     {
         weakSelf.resultLabel.text = [NSString stringWithFormat:@"successfully pinned pin"];
     }
                 andFailure:^(NSError *error)
     {
         weakSelf.resultLabel.text = @"pin it failed";
     }];
}

- (void)createBoardButtonTapped:(UIButton *)button
{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Create Board"
                                                                   message:@"Enter the new board name:"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    __weak ViewController *weakSelf = self;
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSString *boardName = [alert.textFields[0] text];
        [[PDKClient sharedInstance] createBoard:boardName
                               boardDescription:nil
                                    withSuccess:^(PDKResponseObject *responseObject) {
                                        
                                        if ([responseObject isValid]) {
                                            PDKBoard *createdBoard = responseObject.board;
                                            weakSelf.resultLabel.text = [NSString stringWithFormat:@"%@ created!", createdBoard.name];
                                            
                                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                                weakSelf.resultLabel.text = @"";
                                            });
                                        }
                                        
                                    } andFailure:nil];
        
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    
    [alert addTextFieldWithConfigurationHandler:nil];
    [alert addAction:ok];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
    
}


- (void)boardsButtonTapped:(UIButton *)button
{
    BoardsViewController *boardsVC = [[BoardsViewController alloc] init];
    [self.navigationController pushViewController:boardsVC animated:YES];
}



@end


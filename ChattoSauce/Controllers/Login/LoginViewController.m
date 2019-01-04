//
//  ViewController.m
//  ChattoSauce
//
//  Created by Drey Mill on 17/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "LoginViewController.h"
#import "FriendsViewController.h"

@interface LoginViewController ()

@property (strong, nonatomic) UIButton *publicButton;

@end

@implementation LoginViewController

- (UIButton *)publicButton{
    if(!_publicButton){
        _publicButton = [[UIButton alloc] init];//[UIButton buttonWithType:UIButtonTypeSystem];
        [_publicButton setBackgroundColor:[UIColor yellowColor]];
        [_publicButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_publicButton setTitle:@"Go to Chat" forState:UIControlStateNormal];
        _publicButton.layer.cornerRadius = 5;
        _publicButton.layer.masksToBounds = true;
        _publicButton.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _publicButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.grayColor;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor]}];
    self.navigationItem.title = @"ChattoSauce";
    
    [self setupGoToChatButton];
}

-(void)setupGoToChatButton{
    [self.view addSubview:self.publicButton];
    [[self.publicButton.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor] setActive:true];
    [[self.publicButton.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor] setActive:true];
    [[self.publicButton.widthAnchor constraintEqualToConstant:150] setActive:true];
    [[self.publicButton.heightAnchor constraintEqualToConstant:50] setActive:true];
    
    [self.publicButton addTarget:self action:@selector(openChatVC) forControlEvents:UIControlEventTouchUpInside];
}

-(void)openChatVC{
    UINavigationController *navController = (UINavigationController *)[UIApplication sharedApplication].keyWindow.rootViewController;
//    navController.navigationBarHidden = true;
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    FriendsViewController *friendsvc = [[FriendsViewController alloc] initWithCollectionViewLayout:flowLayout];
    [navController pushViewController:friendsvc animated:true];
}

@end

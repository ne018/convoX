//
//  CustomTabBarController.m
//  ChattoSauce
//
//  Created by Drey Mill on 28/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//


#import "FriendsViewController.h"
#import "CustomTabBarController.h"

@interface CustomTabBarController ()

@end

@implementation CustomTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // layout custom view controllers
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    FriendsViewController *friendsvc = [[FriendsViewController alloc] initWithCollectionViewLayout:flowLayout];
    UINavigationController *recentMessagesNavController = [[UINavigationController alloc] initWithRootViewController:friendsvc];
    recentMessagesNavController.tabBarItem.title = @"Recent";
    recentMessagesNavController.tabBarItem.image = [UIImage imageNamed:@"recent"];
    
    self.viewControllers = @[recentMessagesNavController, [self createDummyNavControllerWithTitle:@"Calls" withImageName:@"calls"], [self createDummyNavControllerWithTitle:@"Groups" withImageName:@"users"], [self createDummyNavControllerWithTitle:@"People" withImageName:@"list"], [self createDummyNavControllerWithTitle:@"Settings" withImageName:@"settings"]];
}

- (UINavigationController *)createDummyNavControllerWithTitle:(NSString *)title withImageName:(NSString *)imageName{
    UIViewController *dummyVC = [UIViewController new];
    UINavigationController *dummynavController = [[UINavigationController alloc] initWithRootViewController:dummyVC];
    dummynavController.tabBarItem.title = title;
    dummynavController.tabBarItem.image = [UIImage imageNamed:imageName];
    return dummynavController;
}


@end

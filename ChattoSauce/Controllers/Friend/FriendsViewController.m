//
//  FriendsViewController.m
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "FriendsViewController.h"
#import "FriendsViewcontroller+SetupData.h"
#import "FriendCell.h"
#import "ChatLogViewController.h"

@interface FriendsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation FriendsViewController

static NSString * const reuseIdentifier = @"FriendCell";

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"Recent";
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.alwaysBounceVertical = true;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[FriendCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupData];
}

-(NSMutableArray *)messages{
    if(!_messages){
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of items
    NSUInteger count = 0;
    if(self.messages.count > 0){
        count = self.messages.count;
    }
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FriendCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[FriendCell alloc] init];
    }
    
    if(self.messages.count > 0){
        cell.message = [self.messages objectAtIndex:indexPath.row];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    ChatLogViewController *chatLogVC = [[ChatLogViewController alloc] initWithCollectionViewLayout:flowLayout];
    chatLogVC.myFriend = [[self.messages objectAtIndex:indexPath.item] myFriend];
    [self.navigationController pushViewController:chatLogVC animated:true];
    
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    // do code here
    return CGSizeMake(self.view.frame.size.width, 100);
}

#pragma mark <UICollectionViewDelegate>


@end

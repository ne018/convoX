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
#import "LoginViewController.h"
#import "PeopleViewController.h"
#import "Firebase.h"

@interface FriendsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation FriendsViewController

static NSString * const reuseIdentifier = @"FriendCell";

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = false;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self checkIfUserIsLogged];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(handleLogout)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Compose" style:UIBarButtonItemStylePlain target:self action:@selector(handleNewMessage)];
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    self.navigationItem.title = @"Recent";
    self.collectionView.alwaysBounceVertical = true;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[FriendCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self setupData];
}

-(void)handleNewMessage{
    PeopleViewController *peopleVC = [[PeopleViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:peopleVC];
    [self presentViewController:navController animated:true completion:nil];
}

-(void)checkIfUserIsLogged{
    if([FIRAuth.auth currentUser].uid == nil){
        [self performSelector:@selector(handleLogout) withObject:nil afterDelay:0];
    }else{
        NSString *uid = FIRAuth.auth.currentUser.uid;
        [[[FIRDatabase.database.reference child:@"users"] child:uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSDictionary *snapshotDict = (NSDictionary *)snapshot;
        } withCancelBlock:nil];
    }
}

- (void)handleLogout{
    
    @try {
        NSError *errorSignout;
        [FIRAuth.auth signOut:&errorSignout];
    } @catch (NSException *exception) {
        NSLog(@"error logout: %@", exception);
    } @finally {
        //
    }
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [self presentViewController:loginVC animated:true completion:nil];
}

- (NSMutableArray *)messages{
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

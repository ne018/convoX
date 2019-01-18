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
#import "OpenDatabase.h"

@interface FriendsViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSTimer *timer;

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
    
    [self observeUserMessages];
}

-(void)observeUserMessages{
//    [self.messages removeAllObjects];
//    [self.messagesDictionary removeAllObjects];
//    [self.collectionView reloadData];
    
    NSString *uid = [FIRAuth.auth.currentUser uid];
    
    if(uid.length > 0){
        FIRDatabaseReference *ref = [[FIRDatabase.database.reference child:@"user-messages"] child:uid];
        [ref observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            NSString *uniqueID = snapshot.key;
            FIRDatabaseReference *messageReference = [[FIRDatabase.database.reference child:@"messages"] child:uniqueID];
            [messageReference observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                
                NSDictionary *messageSnapshot = (NSDictionary *)snapshot.value;
                if(messageSnapshot.count > 0){
                    Message *message = [[Message alloc] initWithDictionary:messageSnapshot];
                    
                    [self.messagesDictionary setObject:message forKey:message.chatPartnerId];
                    self.messages = self.messagesDictionary.allValues.mutableCopy;
                    
                    NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
                    NSArray *sortedMsgs = [self.messages.mutableCopy sortedArrayUsingDescriptors:@[descriptor]];
                    
                    self.messages = sortedMsgs.mutableCopy;
                    
                    [self.timer invalidate];
                    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(handleReloadTable) userInfo:nil repeats:false];
                }
                
            } withCancelBlock:nil];
        } withCancelBlock:nil];
    }
}

-(void)handleReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"reload collectionview");
        [self.collectionView reloadData];
    });
}

-(void)handleNewMessage{
    PeopleViewController *peopleVC = [[PeopleViewController alloc] init];
    [peopleVC setCancelBarButton];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:peopleVC];
    [self presentViewController:navController animated:true completion:nil];
}

-(void)checkIfUserIsLogged{
    if([FIRAuth.auth currentUser].uid == nil){
        [self performSelector:@selector(handleLogout) withObject:nil afterDelay:0];
    }else{
        NSString *uid = FIRAuth.auth.currentUser.uid;
        if(uid.length > 0){
            [[[FIRDatabase.database.reference child:@"users"] child:uid] observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
                NSDictionary *snapshotDict = (NSDictionary *)snapshot;
            } withCancelBlock:nil];
        }
    }
}

- (void)handleLogout{
    
    //clear tables
    NSArray *tablesCS = @[@"friend", @"message"];
    [OpenDatabase truncateAllTables:tablesCS];
    
    NSError *errorSignout;
    
    @try {
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

- (NSMutableDictionary *)messagesDictionary{
    if(!_messagesDictionary){
        _messagesDictionary = [[NSMutableDictionary alloc] init];
    }
    return _messagesDictionary;
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

//
//  PeopleViewController.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "PeopleViewController.h"
#import "Friend.h"
#import "FriendHelper.h"
#import "PeopleCell.h"
#import "ChatLogViewController.h"
#import "Firebase.h"

@interface PeopleViewController ()

@end

static NSString * const reuseIdentifier = @"PeopleCell";

@implementation PeopleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(handleCancel)];
    
    [self.tableView registerClass:[PeopleCell self] forCellReuseIdentifier:reuseIdentifier];

    [self fetchingFiends];
}

-(NSMutableArray *)people{
    if(!_people){
        _people = [[NSMutableArray alloc] init];
    }
    return _people;
}

-(void)fetchingFiends{
    NSMutableArray *fetchFriends = [[FriendHelper instance] fetchFriends];
    if(fetchFriends.count > 0){
        for (Friend *friend in fetchFriends) {
            if(![friend.email isEqualToString:[FIRAuth.auth currentUser].email]){
                [self.people addObject:friend];
            }
        }
        NSLog(@"count people: %lu", (unsigned long)self.people.count);
    }
}

-(void)handleCancel{
    [self dismissViewControllerAnimated:true completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(self.people.count > 0){
        return self.people.count;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[PeopleCell alloc] init];
    }
    
    if(self.people.count > 0){
        cell.myFriend = [self.people objectAtIndex:indexPath.row];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    ChatLogViewController *chatLogVC = [[ChatLogViewController alloc] initWithCollectionViewLayout:flowLayout];
    chatLogVC.myFriend = [self.people objectAtIndex:indexPath.item];
    [self.navigationController pushViewController:chatLogVC animated:true];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 85.0f;
}


@end

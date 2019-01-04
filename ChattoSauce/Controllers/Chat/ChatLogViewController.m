//
//  ChatLogViewController.m
//  ChattoSauce
//
//  Created by Drey Mill on 03/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "ChatLogViewController.h"
#import "ChatLogCell.h"
#import "MessageHelper.h"
#import "Message.h"
#import "FriendHelper.h"
#import "prefixHeader.h"

@interface ChatLogViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView *messageInputContainerView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) NSLayoutConstraint *inputBottomConstraint;
@property (nonatomic, strong) UIButton *sendButton;

@end

@implementation ChatLogViewController

static NSString * const reuseIdentifier = @"ChatLogCell";

-(void)setMyFriend:(Friend *)myFriend{
    _myFriend = myFriend;
    
    self.navigationItem.title = myFriend.name;
    
    // fetch messages for this selected friend
    self.messages = (NSMutableArray *)myFriend.messages.allObjects;
    NSMutableArray *fetchMessages = [[MessageHelper instance] fetchMessagesByFriendID:myFriend.friendid];
    if(fetchMessages.count > 0){
        for (Message *msg in fetchMessages) {
            Friend *friend = [[FriendHelper instance] getFriendByParam:@{@"friendid":msg.fkfriendid}];
            msg.myFriend = friend;
            [self.messages addObject:msg];
        }
    }
}

-(NSMutableArray *)messages{
    if(!_messages){
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

-(UIView *)messageInputContainerView{
    if(!_messageInputContainerView){
        _messageInputContainerView = [[UIView alloc] init];
        _messageInputContainerView.backgroundColor = [UIColor whiteColor];
    }
    return _messageInputContainerView;
}

- (UITextField *)inputTextField{
    if(!_inputTextField){
        _inputTextField = [[UITextField alloc] init];
        _inputTextField.placeholder = @"Compose message...";
    }
    return _inputTextField;
}

- (UIButton *)sendButton{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton setTitleColor:THEMECOLOR1 forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
    }
    return _sendButton;
}

- (void)viewWillAppear:(BOOL)animated{
    [self scrollToLastChatContentSize:true];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = true;
    self.collectionView.alwaysBounceVertical = true;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
//    self.edgesForExtendedLayout = UIEdgeInsetsZero;
    [self.collectionView registerClass:[ChatLogCell self] forCellWithReuseIdentifier:reuseIdentifier];
    
    [self.view addSubview:self.messageInputContainerView];
    [self.view addConstraintsWithFormat:@"H:|[v0]|" withViews:self.messageInputContainerView, nil];
    [self.view addConstraintsWithFormat:@"V:[v0(48)]" withViews:self.messageInputContainerView, nil];

    self.inputBottomConstraint = [NSLayoutConstraint constraintWithItem:self.messageInputContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint: self.inputBottomConstraint];

    [self setupInputComponents];

    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    
    NSLog(@"CollectionView Frame: %@", NSStringFromCGRect(self.collectionView.frame));
}

- (void)handleKeyboardNotification:(NSNotification *)notification{
    if([notification userInfo] != nil){
        CGRect keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"frame: %@", NSStringFromCGRect(keyboardSize));
        
        CGFloat collectionViewContentHeight = self.collectionView.contentSize.height;
        BOOL readyForScroll = collectionViewContentHeight > mainScreenHeight;
        BOOL isKeyboardShowing = notification.name == UIKeyboardWillShowNotification;
        self.inputBottomConstraint.constant = isKeyboardShowing && !readyForScroll ? -keyboardSize.size.height : 0;
        
        [UIView animateWithDuration:0 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            if(readyForScroll){
                [self adjustCollectionView:isKeyboardShowing keyboardSize:keyboardSize];
            }
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self scrollToLastChatContentSize:false];
        }];
    }
}

- (void)scrollToLastChatContentSize:(BOOL)contentSize{
    if(contentSize){
        CGFloat collectionViewContentHeight = self.collectionView.contentSize.height;
        CGFloat collectionViewFrameHeightAfterInserts = self.collectionView.frame.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);
        
        if(collectionViewContentHeight > collectionViewFrameHeightAfterInserts) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - self.collectionView.frame.size.height + 50) animated:NO];
        }
    }else{
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0];
        [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:true];
    }
}

- (void)adjustCollectionView:(BOOL)isKeyboardShowing keyboardSize:(CGRect)keyboardSize{
    CGRect f = self.view.frame;
    if(isKeyboardShowing){
        self.view.frame = CGRectMake(f.origin.x, -keyboardSize.size.height, f.size.width, f.size.height);
    }else{
        self.view.frame = CGRectMake(f.origin.x, 0.0f, f.size.width, f.size.height);
    }
}

- (void)setupInputComponents{
    
    UIView *topBorderView = [[UIView alloc] init];
    topBorderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self.messageInputContainerView addSubview: self.inputTextField];
    [self.messageInputContainerView addSubview: self.sendButton];
    [self.messageInputContainerView addSubview: topBorderView];
    
    [self.messageInputContainerView addConstraintsWithFormat:@"H:|-8-[v0][v1(60)]|" withViews:self.inputTextField, self.sendButton,nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.inputTextField, nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.sendButton, nil];
    
    [self.messageInputContainerView addConstraintsWithFormat:@"H:|[v0]|" withViews:topBorderView, nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0(0.5)]" withViews:topBorderView, nil];
    
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
    ChatLogCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    if(!cell){
        cell = [[ChatLogCell alloc] init];
    }
    
    NSString *messageText = [[self.messages objectAtIndex:indexPath.item] text];
    NSString *profileImageName = [[self.messages objectAtIndex:indexPath.item] myFriend].profileImageName;
    
    
    if(profileImageName.length > 0){
        cell.profileImageView.image = [UIImage imageNamed:profileImageName];
    }
    
    if(messageText.length > 0){
        cell.messageTextView.text = messageText;
        
        CGSize size = CGSizeMake(250, 1000);
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGRect estimatedFrame = [messageText boundingRectWithSize:size options:options attributes:attributes context:nil];
        
        if(![[self.messages objectAtIndex:indexPath.item] isSender].boolValue){
            cell.messageTextView.frame = CGRectMake(48 + 8, 0, estimatedFrame.size.width + 16, estimatedFrame.size.height + 20);
            cell.textBubbleView.frame = CGRectMake(48 - 10, -4, estimatedFrame.size.width + 16 + 8 + 10, estimatedFrame.size.height + 20 + 6);
            cell.profileImageView.hidden = false;
//            cell.textBubbleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
            cell.bubbleImageView.image = GRAYBUBBLEIMAGE;
            cell.bubbleImageView.tintColor = [UIColor colorWithWhite:0.95 alpha:1];
            cell.messageTextView.textColor = [UIColor blackColor];
        }else{
            cell.messageTextView.frame = CGRectMake(self.view.frame.size.width - estimatedFrame.size.width - 16 - 16 - 8, 0, estimatedFrame.size.width + 16, estimatedFrame.size.height + 20);
            cell.textBubbleView.frame = CGRectMake(self.view.frame.size.width - estimatedFrame.size.width - 16 - 8 - 16 - 10, -4, estimatedFrame.size.width + 16 + 8 + 10, estimatedFrame.size.height + 20 + 6);
            cell.profileImageView.hidden = true;
//            cell.textBubbleView.backgroundColor = [UIColor colorWithRed:0 green:137/255 blue:249/255 alpha:1];
            cell.bubbleImageView.image = BLUEBUBBLEIMAGE;
            cell.bubbleImageView.tintColor = THEMECOLOR1;
            cell.messageTextView.textColor = [UIColor whiteColor];
        }

    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *messageText = [[self.messages objectAtIndex:indexPath.item] text];
    if(messageText.length > 0){
        CGSize size = CGSizeMake(250, 1000);
        NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
        CGRect estimatedFrame = [messageText boundingRectWithSize:size options:options attributes:attributes context:nil];
        
        return CGSizeMake(self.view.frame.size.width, estimatedFrame.size.height + 20);
    }
    
    return CGSizeMake(self.view.frame.size.width, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.inputTextField endEditing:true];
}


@end

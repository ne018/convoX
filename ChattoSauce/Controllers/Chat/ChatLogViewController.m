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
#import "FriendsViewController+SetupData.h"
#import "Firebase.h"

@interface ChatLogViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIView *messageInputContainerView;
@property (nonatomic, strong) UITextField *inputTextField;
@property (nonatomic, strong) NSLayoutConstraint *inputBottomConstraint;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) UIButton *sendImage;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIView *inputContainerView;

@end

@implementation ChatLogViewController{
    BOOL isKeyboardShowing;
    CGRect startingFrame;
    UIView *blackBackgroundView;
    UIImageView *startingImageViewClone;
}

static NSString * const reuseIdentifier = @"ChatLogCell";

-(void)setMyFriend:(Friend *)myFriend{
    _myFriend = myFriend;
    
    self.navigationItem.title = myFriend.name;
    
    // fetch messages for this selected friend
//    self.messages = (NSMutableArray *)myFriend.messages.allObjects;
//    NSMutableArray *fetchMessages = [[MessageHelper instance] fetchMessagesByFriendID:myFriend.friendid];
//    if(fetchMessages.count > 0){
//        for (Message *msg in fetchMessages) {
//            Friend *friend = [[FriendHelper instance] getFriendByParam:@{@"touniqueid":msg.touniqueid}];
//            msg.myFriend = friend;
//            [self.messages addObject:msg];
//        }
//    }
    
    [self observeMessages];
    
}

-(void)observeMessages{
    NSString *uid = [FIRAuth.auth.currentUser uid];
    if(uid.length == 0){
        return;
    }
    
    FIRDatabaseReference *userMessagesRef = [[FIRDatabase.database.reference child:@"user-messages"] child:uid];
    [userMessagesRef observeEventType:FIRDataEventTypeChildAdded withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
        
        NSString *uniqueID = snapshot.key;
        FIRDatabaseReference *messagesRef = [[FIRDatabase.database.reference child:@"messages"] child:uniqueID];
        [messagesRef observeSingleEventOfType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot * _Nonnull snapshot) {
            
            NSDictionary *messageDict = (NSDictionary *)snapshot.value;
            if(messageDict.count == 0){
                return;
            }
            
            Message *message = [[Message alloc] initWithDictionary:messageDict];
            
            if([message.chatPartnerId isEqualToString:self.myFriend.uniqueid] ){
                Friend *friend = [[FriendHelper instance] getFriendByParam:@{@"uniqueid":message.chatPartnerId}];
                message.myFriend = friend;
                [self.messages addObject:message];
            }
            
            [self.timer invalidate];
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(handleReloadTable) userInfo:nil repeats:false];
            
        } withCancelBlock:nil];
        
    } withCancelBlock:nil];
    
    
}

-(void)handleReloadTable{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"reload collectionview");
        [self.collectionView reloadData];
        [self scrollToLastChatContentSize:false animated:false keyboardSizeHeight:0];
    });
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
        _inputTextField.delegate = self;
        _inputTextField.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _inputTextField;
}

- (UIButton *)sendButton{
    if(!_sendButton){
        _sendButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_sendButton setTitle:@"Send" forState:UIControlStateNormal];
        [_sendButton setTitleColor:THEMECOLOR1 forState:UIControlStateNormal];
        _sendButton.titleLabel.font = [UIFont boldSystemFontOfSize:16];
        [_sendButton addTarget:self action:@selector(handleSend) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _sendButton;
}

-(UIButton *)sendImage{
    if(!_sendImage){
        _sendImage = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendImage setImage:[UIImage imageNamed:@"upload_image_icon"] forState:UIControlStateNormal];
        [_sendImage addTarget:self action:@selector(handleImageSend) forControlEvents:UIControlEventTouchUpInside];
        _sendImage.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _sendImage;
}

- (UIView *)inputContainerView{
    if(!_inputContainerView){
        _inputContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50.0f)];
        _inputContainerView.backgroundColor = [UIColor whiteColor];
        
        UIView *topBorderView = [[UIView alloc] init];
        topBorderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
        topBorderView.translatesAutoresizingMaskIntoConstraints = false;
        
        [_inputContainerView addSubview: self.sendButton];
        [_inputContainerView addSubview: self.inputTextField];
        [_inputContainerView addSubview: self.sendImage];
        [_inputContainerView addSubview: topBorderView];

        [self.sendButton.rightAnchor constraintEqualToAnchor:_inputContainerView.rightAnchor constant:0].active = true;
        [self.sendButton.centerYAnchor constraintEqualToAnchor:_inputContainerView.centerYAnchor constant:0].active = true;
        [self.sendButton.widthAnchor constraintEqualToConstant:80].active = true;
        [self.sendButton.heightAnchor constraintEqualToAnchor:_inputContainerView.heightAnchor constant:0].active = true;
        
        [self.sendImage.leftAnchor constraintEqualToAnchor:_inputContainerView.leftAnchor constant:0].active = true;
        [self.sendImage.topAnchor constraintEqualToAnchor:_inputContainerView.topAnchor constant:0].active = true;
        [self.sendImage.widthAnchor constraintEqualToConstant:44].active = true;
        [self.sendImage.heightAnchor constraintEqualToConstant:44].active = true;
        
        [self.inputTextField.leftAnchor constraintEqualToAnchor:self.sendImage.rightAnchor constant:8].active = true;
        [self.inputTextField.centerYAnchor constraintEqualToAnchor:_inputContainerView.centerYAnchor constant:0].active = true;
        [self.inputTextField.rightAnchor constraintEqualToAnchor:self.sendButton.leftAnchor constant:0].active = true;
        [self.inputTextField.heightAnchor constraintEqualToAnchor:_inputContainerView.heightAnchor constant:0].active = true;

        [topBorderView.topAnchor constraintEqualToAnchor:_inputContainerView.topAnchor constant:0].active = true;
        [topBorderView.leftAnchor constraintEqualToAnchor:_inputContainerView.leftAnchor constant:0].active = true;
        [topBorderView.rightAnchor constraintEqualToAnchor:_inputContainerView.rightAnchor constant:0].active = true;
        [topBorderView.heightAnchor constraintEqualToConstant:0.5].active = true;
    }
    return _inputContainerView;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [[self.collectionView collectionViewLayout] invalidateLayout];
}

-(void)handleSend{
    if(self.inputTextField.text.length > 0){
        @try {

            NSDictionary *properties = @{@"text": self.inputTextField.text, @"type":@"text"};
            [self sendMessageWithProperties: properties];

            /*Message *message = [FriendsViewController createMessageWithText:self.inputTextField.text withFriend:self.myFriend withMinutes:1 isSender:true];
            if(message != nil){
                [self.messages addObject:message];
                NSIndexPath *insertionIndexPath = [NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0];
                [self.collectionView insertItemsAtIndexPaths:@[insertionIndexPath]];
                [self.collectionView scrollToItemAtIndexPath:insertionIndexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:true];
                self.inputTextField.text = nil;
            }*/

        } @catch (NSException *exception) {
            NSLog(@"Err: %@", exception);
        } @finally {
            //
        }

        self.inputTextField.text = nil;
    }

}

-(void)handleImageSend{
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = true;
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    
    [picker dismissViewControllerAnimated:YES completion:^{
        UIImage *selectedImageFromPicker;
        UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
        
        if(editedImage) {
            selectedImageFromPicker = editedImage;
        } else if (originalImage){
            selectedImageFromPicker = originalImage;
        }
        
        if (selectedImageFromPicker != nil){
            [self uploadToFirebaseStorageUsingImage:selectedImageFromPicker];
        }
    }];
    
}

-(void)uploadToFirebaseStorageUsingImage:(UIImage *)image{
    NSString *imageName = [[NSUUID UUID] UUIDString];
    
    //storage reference
    FIRStorage *storage = [FIRStorage storage];
    FIRStorageReference *storeRef = [storage reference];
    FIRStorageReference *imageRef = [[storeRef child:@"messages_images"] child:[NSString stringWithFormat:@"%@.jpg", imageName]];
    
    NSData *uploadData = UIImageJPEGRepresentation(image, 0.1);
    
    if(uploadData != nil){
        
        FIRStorageUploadTask *uploadTask = [imageRef putData:uploadData metadata:nil];
        
        // report progress
        [uploadTask observeStatus:FIRStorageTaskStatusProgress handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
            NSProgress *progress = snapshot.progress;
            double percentComplete = 100.0 * (progress.completedUnitCount) / (progress.totalUnitCount);
            NSLog(@"percentComplete: %f", percentComplete);
        }];
        
        // pause, resume
        
        // success
        [uploadTask observeStatus:FIRStorageTaskStatusSuccess handler:^(FIRStorageTaskSnapshot * _Nonnull snapshot) {
            [imageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
                if(error != nil){
                    NSLog(@"error: %@", error);
                    return;
                }
                if(URL.absoluteString.length == 0) return;
                
                [self sendMessageWithImageURL:URL.absoluteString withImage:image];
            }];

        }];
        
        
//        [imageRef putData:uploadData metadata:nil completion:^(FIRStorageMetadata * _Nullable metadata, NSError * _Nullable error) {
//            if(error != nil){
//                NSLog(@"failed to upload image: %@", error);
//                return;
//            }
//
//            [imageRef downloadURLWithCompletion:^(NSURL * _Nullable URL, NSError * _Nullable error) {
//                if(error != nil){
//                    NSLog(@"error: %@", error);
//                    return;
//                }
//                if(URL.absoluteString.length == 0) return;
//
//                [self sendMessageWithImageURL:URL.absoluteString withImage:image];
//            }];
//
//        }];
        
        
    }
}

-(void)sendMessageWithProperties:(NSDictionary *)properties{
    FIRDatabaseReference *msgRef = [FIRDatabase.database.reference child:@"messages"];
    FIRDatabaseReference *childRef = msgRef.childByAutoId;
    
    NSString *toUniqueID = self.myFriend.uniqueid;
    NSString *fromUniqueID = [FIRAuth.auth.currentUser uid];
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    
    NSMutableDictionary *valuesMsg = [[NSMutableDictionary alloc] initWithDictionary:@{@"toUniqueId":toUniqueID, @"fromUniqueId":fromUniqueID, @"date":[NSString stringWithFormat:@"%f", timeStamp]}];
    
    [valuesMsg setValuesForKeysWithDictionary:properties];
    
    [childRef updateChildValues:valuesMsg withCompletionBlock:^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref) {
        if(error != nil){
            NSLog(@"error: %@", error);
            return;
        }
        
        FIRDatabaseReference *userMessagesRef = [[FIRDatabase.database.reference child:@"user-messages"] child:fromUniqueID];
        NSString *messageId = childRef.key;
        [userMessagesRef updateChildValues:@{messageId: @1}];
        
        FIRDatabaseReference *recipientUserMessagesRef = [[FIRDatabase.database.reference child:@"user-messages"] child:toUniqueID];
        [recipientUserMessagesRef updateChildValues:@{messageId: @1}];
        
    }];
}

-(void)sendMessageWithImageURL:(NSString *)urlString withImage:(UIImage *)image{
    NSDictionary *properties = @{@"type":@"image", @"text":@"Sent an image", @"imageUrl": urlString, @"imageWidth":[NSNumber numberWithFloat:image.size.width], @"imageHeight":[NSNumber numberWithFloat:image.size.height]};
    [self sendMessageWithProperties:properties];
}

- (void)viewWillAppear:(BOOL)animated{
    [self scrollToLastChatContentSize:true animated:false keyboardSizeHeight:0];
}

-(void)handleSimulate{
    @try {
        Message *message = [FriendsViewController createMessageWithText:@"Here's a text message that was sent few minutes ago..." withFriend:self.myFriend withMinutes:1 isSender:false];
        if(message != nil){
            [self.messages addObject:message];
            NSArray *tempArray = [[NSArray alloc] initWithArray:self.messages];
            NSSortDescriptor * descriptor = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:YES];
            NSArray *sortedMsgs = [tempArray sortedArrayUsingDescriptors:@[descriptor]];
            [self.messages removeAllObjects];
            [self.messages addObjectsFromArray:sortedMsgs];
//            NSMutableArray *fetchMessages = [[MessageHelper instance] fetchMessagesByFriendID:self.myFriend.friendid];
//            if(fetchMessages.count > 0){
//                for (Message *msg in fetchMessages) {
//                    Friend *friend = [[FriendHelper instance] getFriendByParam:@{@"friendid":msg.fkfriendid}];
//                    msg.myFriend = friend;
//                    [self.messages addObject:msg];
//                }
//            }
            
            NSInteger itemMsg = [self.messages indexOfObject:message];
            NSIndexPath *insertionIndexPath = [NSIndexPath indexPathForItem:itemMsg inSection:0];
            [self.collectionView insertItemsAtIndexPaths:@[insertionIndexPath]];
            [self scrollToLastChatContentSize:false animated:true keyboardSizeHeight:0];
        }
    } @catch (NSException *exception) {
        NSLog(@"Err: %@", exception);
    } @finally {
        //
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Simulate" style:UIBarButtonItemStylePlain target:self action:@selector(handleSimulate)];

    self.tabBarController.tabBar.hidden = true;
    self.collectionView.alwaysBounceVertical = true;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
//    self.edgesForExtendedLayout = UIEdgeInsetsZero;
    [self.collectionView registerClass:[ChatLogCell self] forCellWithReuseIdentifier:reuseIdentifier];
    self.collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeInteractive;
    
//    [self.view addSubview:self.messageInputContainerView];
//    [self.view addConstraintsWithFormat:@"H:|[v0]|" withViews:self.messageInputContainerView, nil];
//    [self.view addConstraintsWithFormat:@"V:[v0(48)]" withViews:self.messageInputContainerView, nil];

//    [self setupInputComponents];
    [self setupKeyboardObservers];
    
    NSLog(@"CollectionView Frame: %@", NSStringFromCGRect(self.collectionView.frame));
}

-(void)setupKeyboardObservers{
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillShowNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardNotification:) name:UIKeyboardWillHideNotification object:nil];
    [NSNotificationCenter.defaultCenter addObserver:self selector:@selector(handleKeyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
}

-(void)handleKeyboardDidShow:(NSNotification *)notification{
    if([notification userInfo] != nil){
        CGRect keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        if(keyboardSize.size.height > 50.0f){
            [self scrollToLastChatContentSize:true animated:true keyboardSizeHeight:keyboardSize.size.height];
        }
    }
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NSNotificationCenter.defaultCenter removeObserver:self];
}

- (void)handleKeyboardNotification:(NSNotification *)notification{
    if([notification userInfo] != nil){
        CGRect keyboardSize = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSLog(@"frame: %@", NSStringFromCGRect(keyboardSize));
        NSTimeInterval keyboardDuration = [[notification.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        CGFloat collectionViewContentHeight = self.collectionView.contentSize.height;
        BOOL readyForScroll = collectionViewContentHeight > mainScreenHeight;
        isKeyboardShowing = notification.name == UIKeyboardWillShowNotification;
        
        if(isKeyboardShowing){
            if(keyboardSize.size.height > 50.0f){
                UIEdgeInsets contentInsets = self.collectionView.contentInset;
                contentInsets.bottom = keyboardSize.size.height;
                self.collectionView.contentInset = contentInsets;
                self.collectionView.scrollIndicatorInsets = contentInsets;
            }
        }else{
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0);
            self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 50, 0);
        }
        
//        self.inputBottomConstraint.constant = isKeyboardShowing? -keyboardSize.size.height : 0;
        [UIView animateWithDuration:0 delay:keyboardDuration options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            if(readyForScroll){
                [self scrollToLastChatContentSize:false animated:true keyboardSizeHeight:self->isKeyboardShowing ? keyboardSize.size.height : 0];
            }
        }];
    }
}

- (void)scrollToLastChatContentSize:(BOOL)contentSize animated:(BOOL)animated keyboardSizeHeight:(CGFloat)keyboardSizeHeight{
    if(contentSize){
        CGFloat deductSize = keyboardSizeHeight > 0 ? keyboardSizeHeight : self.collectionView.frame.size.height;
        CGFloat collectionViewContentHeight = self.collectionView.contentSize.height;
        CGFloat collectionViewFrameHeightAfterInserts = self.collectionView.frame.size.height - (self.collectionView.contentInset.top + self.collectionView.contentInset.bottom);
        
        if(collectionViewContentHeight > collectionViewFrameHeightAfterInserts) {
            [self.collectionView setContentOffset:CGPointMake(0, self.collectionView.contentSize.height - deductSize + 50) animated:animated];
        }
    }else{
        if(self.messages.count > 0){
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:self.messages.count - 1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionBottom animated:animated];
        }
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
    
    self.inputBottomConstraint = [NSLayoutConstraint constraintWithItem:self.messageInputContainerView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    [self.view addConstraint: self.inputBottomConstraint];

    
    UIView *topBorderView = [[UIView alloc] init];
    topBorderView.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    
    [self.messageInputContainerView addSubview: self.inputTextField];
    [self.messageInputContainerView addSubview: self.sendButton];
    [self.messageInputContainerView addSubview: self.sendImage];
    [self.messageInputContainerView addSubview: topBorderView];
    
    [self.messageInputContainerView addConstraintsWithFormat:@"H:|[v0(44)]-2-[v1][v2(60)]|" withViews:self.sendImage,self.inputTextField, self.sendButton,nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0(44)]|" withViews:self.sendImage, nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.inputTextField, nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.sendButton, nil];
    
    [self.messageInputContainerView addConstraintsWithFormat:@"H:|[v0]|" withViews:topBorderView, nil];
    [self.messageInputContainerView addConstraintsWithFormat:@"V:|[v0(0.5)]" withViews:topBorderView, nil];
    
}

- (UIView *)inputAccessoryView{
    [super inputAccessoryView];

    return self.inputContainerView;
}

- (BOOL)canBecomeFirstResponder{
    return true;
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
    Message *message = (Message *)[self.messages objectAtIndex:indexPath.item];
    cell.chatLogController = self;
    cell = [self setupCell:cell withMessage:message];
    
    return cell;
}

-(ChatLogCell *)setupCell:(ChatLogCell *)cell withMessage:(Message *)message{
    
    NSString *messageText = message.text;
    NSString *profileImageName = message.myFriend.profileimagename;
    
    if(profileImageName.length > 0){
        [cell.profileImageView loadImageWithUrlString:profileImageName withPlaceholder:@"avatar" completion:^{}];
    }
    
    if([message.type isEqualToString:@"text"]){
        if(messageText.length > 0){
            cell.messageTextView.hidden = false;
            cell.messageImageView.hidden = true;
            cell.messageTextView.text = messageText;
            cell.bubbleImageView.hidden = false;
            
            CGSize size = CGSizeMake(250, 1000);
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
            CGRect estimatedFrame = [messageText boundingRectWithSize:size options:options attributes:attributes context:nil];
            
            //        if(![[self.messages objectAtIndex:indexPath.item] isSender].boolValue){
            if(![message.fromuniqueid isEqualToString:[FIRAuth.auth.currentUser uid]]){
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
    }else if([message.type isEqualToString:@"image"]){
        if(message.imageUrl.length > 0){
            cell.messageTextView.hidden = true;
            cell.messageImageView.hidden = false;
            cell.bubbleImageView.hidden = true;
            [cell.messageImageView loadImageWithUrlString:message.imageUrl withPlaceholder:@"" completion:^{}];
            
            CGFloat height = [message.imageHeight floatValue] / [message.imageWidth floatValue] * 200;
            
            if(![message.fromuniqueid isEqualToString:[FIRAuth.auth.currentUser uid]]){
                cell.textBubbleView.frame = CGRectMake(48 - 4, 8, 200, height);
                cell.profileImageView.hidden = false;
            }else{
                cell.textBubbleView.frame = CGRectMake(self.view.frame.size.width - 200 - 16, -4, 200, height);
                cell.profileImageView.hidden = true;
                cell.messageTextView.textColor = [UIColor whiteColor];
            }
        }
    }
    
    return cell;
}

-(void)performZoomInStartingImageView:(UIImageView *)startingImageView{
    NSLog(@"zoom in");
    
    startingImageViewClone = startingImageView;
    startingImageViewClone.hidden = true;
    
    startingFrame = [startingImageView.superview convertRect:startingImageView.frame toView:nil];
    
    UIImageView *zoomingImageView = [[UIImageView alloc] initWithFrame:startingFrame];
    zoomingImageView.image = startingImageView.image;
    UITapGestureRecognizer *tapZoomOut = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomOut:)];
    zoomingImageView.userInteractionEnabled = true;
    [zoomingImageView addGestureRecognizer: tapZoomOut];
    
    UIWindow *keyWindow = [UIApplication.sharedApplication keyWindow];
    blackBackgroundView = [[UIView alloc] initWithFrame:keyWindow.frame];
    blackBackgroundView.backgroundColor = [UIColor blackColor];
    blackBackgroundView.alpha = 0;
    [keyWindow addSubview:blackBackgroundView];
    [keyWindow addSubview:zoomingImageView];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self->blackBackgroundView.alpha = 1;
        self.inputContainerView.alpha = 0;
        
        CGFloat height = self->startingFrame.size.height / self->startingFrame.size.width * keyWindow.frame.size.width;
        zoomingImageView.frame = CGRectMake(0, 0, keyWindow.frame.size.width, height);
        zoomingImageView.center = keyWindow.center;
    } completion:^(BOOL finished) {
    }];
    
}

-(void)handleZoomOut:(UITapGestureRecognizer *)tapGesture{
    if([tapGesture.view isKindOfClass:UIImageView.class]){
        UIImageView *zoomoutImageView = (UIImageView *)tapGesture.view;
        zoomoutImageView.layer.cornerRadius = 16;
        zoomoutImageView.layer.masksToBounds = true;
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            zoomoutImageView.frame = self->startingFrame;
            self->blackBackgroundView.alpha = 0;
            self.inputContainerView.alpha = 1;
        } completion:^(BOOL finished) {
            [zoomoutImageView removeFromSuperview];
            self->startingImageViewClone.hidden = false;
        }];
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self handleSend];
    return true;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    Message *message = (Message *)[self.messages objectAtIndex:indexPath.item];
    NSString *messageText = message.text;
    
    if([message.type isEqualToString:@"text"]){
        if(messageText.length > 0){
            CGSize size = CGSizeMake(250, 1000);
            NSStringDrawingOptions options = NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
            NSDictionary *attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:18]};
            CGRect estimatedFrame = [messageText boundingRectWithSize:size options:options attributes:attributes context:nil];
            
            return CGSizeMake(self.view.frame.size.width, estimatedFrame.size.height + 20);
        }
    }
    
    CGFloat width = mainScreenWidth;
    CGFloat height = [message.imageHeight floatValue] / [message.imageWidth floatValue] * 200 + 10;
    return CGSizeMake(width, height);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(8, 0, 0, 0);
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.inputTextField endEditing:true];
}


@end

//
//  ChatLogViewController.h
//  ChattoSauce
//
//  Created by Drey Mill on 03/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChatLogViewController : UICollectionViewController

@property (nonatomic, strong) Friend *myFriend;
@property (nonatomic, strong) NSMutableArray *messages;

-(void)performZoomInStartingImageView:(UIImageView *)startingImageView;

@end

NS_ASSUME_NONNULL_END

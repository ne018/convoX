//
//  FriendCell.h
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "BaseCell.h"
#import <UIKit/UIKit.h>
#import "Message.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendCell : BaseCell

@property (nonatomic, strong) Message *message;


@end

NS_ASSUME_NONNULL_END

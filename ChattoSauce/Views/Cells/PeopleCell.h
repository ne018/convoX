//
//  PeopleCell.h
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Friend.h"
#import "CachedImageView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PeopleCell : UITableViewCell

@property (nonatomic, strong) CachedImageView *profileImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *emailLabel;
@property (nonatomic, strong) Friend *myFriend;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end

NS_ASSUME_NONNULL_END

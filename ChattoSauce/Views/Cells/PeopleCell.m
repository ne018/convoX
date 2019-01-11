//
//  PeopleCell.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "PeopleCell.h"

@interface PeopleCell()

@end

@implementation PeopleCell

- (CachedImageView *)profileImage{
    if(!_profileImage){
        _profileImage = [[CachedImageView alloc] init];
        _profileImage.contentMode = UIViewContentModeScaleAspectFit;
        _profileImage.image = [UIImage imageNamed:@"avatar"];
        _profileImage.layer.cornerRadius = 30;
        _profileImage.layer.masksToBounds = true;
        _profileImage.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _profileImage;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Reese";
        _nameLabel.font = [UIFont boldSystemFontOfSize:19];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _nameLabel;
}

-(UILabel *)emailLabel{
    if(!_emailLabel){
        _emailLabel = [[UILabel alloc] init];
        _emailLabel.text = @"reese@personofinterest.com";
        _emailLabel.textColor = [UIColor lightGrayColor];
        _emailLabel.font = [UIFont systemFontOfSize:15];
        _emailLabel.translatesAutoresizingMaskIntoConstraints = false;
    }
    return _emailLabel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];

        [self setupView];
    }
    return self;
}

-(void)setMyFriend:(Friend *)myFriend{
    _myFriend = myFriend;
    self.nameLabel.text = myFriend.name;
    self.emailLabel.text = myFriend.email;
    
    [self.profileImage loadImageWithUrlString:myFriend.profileimagename withPlaceholder:@"avatar" completion:^{
        
    }];
    // load other data here
}

-(void)setupView{
    [self.contentView addSubview:self.profileImage];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.emailLabel];
    
    [self.profileImage.leftAnchor constraintEqualToAnchor:self.contentView.leftAnchor constant:12].active = true;
    [self.profileImage.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:12].active = true;
    [self.profileImage.widthAnchor constraintEqualToConstant:60].active = true;
    [self.profileImage.heightAnchor constraintEqualToConstant:60].active = true;
    
    [self.nameLabel.leftAnchor constraintEqualToAnchor:self.profileImage.rightAnchor constant:10].active = true;
    [self.nameLabel.topAnchor constraintEqualToAnchor:self.contentView.topAnchor constant:20].active = true;
    [self.nameLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:0].active = true;
    [self.nameLabel.heightAnchor constraintEqualToConstant:20].active = true;
    
    [self.emailLabel.leftAnchor constraintEqualToAnchor:self.profileImage.rightAnchor constant:10].active = true;
    [self.emailLabel.topAnchor constraintEqualToAnchor:self.nameLabel.bottomAnchor constant:0].active = true;
    [self.emailLabel.rightAnchor constraintEqualToAnchor:self.contentView.rightAnchor constant:0].active = true;
    [self.emailLabel.heightAnchor constraintEqualToConstant:25].active = true;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  FriendCell.m
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "FriendCell.h"

@interface FriendCell()

@property (strong,nonatomic) UIImageView *profileImgVw;
@property (strong,nonatomic) UIView *dividerLineVw;
@property (strong,nonatomic) UILabel *nameLabel;
@property (strong,nonatomic) UILabel *messageLabel;
@property (strong,nonatomic) UILabel *timeLabel;
@property (strong,nonatomic) UIImageView *hasReadImgVw;

@end

@implementation FriendCell

-(UIImageView *)profileImgVw{
    if(!_profileImgVw){
        _profileImgVw = [[UIImageView alloc] init];
        _profileImgVw.contentMode = UIViewContentModeScaleAspectFill;
        _profileImgVw.layer.cornerRadius = 30;
        _profileImgVw.layer.masksToBounds = true;
    }
    return _profileImgVw;
}

-(UIView *)dividerLineVw{
    if(!_dividerLineVw){
        _dividerLineVw = [[UIView alloc] init];
        _dividerLineVw.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.5];
    }
    return _dividerLineVw;
}

-(UILabel *)nameLabel{
    if(!_nameLabel){
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"Steve Jobs";
        _nameLabel.font = [UIFont systemFontOfSize:18];
    }
    return _nameLabel;
}

-(UILabel *)messageLabel{
    if(!_messageLabel){
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.text = @"Your friend's message or something else...";
        _messageLabel.textColor = [UIColor darkGrayColor];
        _messageLabel.font = [UIFont systemFontOfSize:13];
    }
    return _messageLabel;
}

-(UILabel *)timeLabel{
    if(!_timeLabel){
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.text = @"12:05 pm";
        _timeLabel.font = [UIFont systemFontOfSize:15];
        _timeLabel.textAlignment = NSTextAlignmentRight;
    }
    return _timeLabel;
}

-(UIImageView *)hasReadImgVw{
    if(!_hasReadImgVw){
        _hasReadImgVw = [[UIImageView alloc] init];
        _hasReadImgVw.contentMode = UIViewContentModeScaleAspectFill;
        _hasReadImgVw.layer.cornerRadius = 10;
        _hasReadImgVw.layer.masksToBounds = true;
    }
    return _hasReadImgVw;
}

-(void)setMessage:(Message *)message{
    _message = message;
    self.nameLabel.text = message.myFriend.name;
    self.messageLabel.text = message.text;
    
    if(message.myFriend.profileimagename != nil){
        self.profileImgVw.image = [UIImage imageNamed:message.myFriend.profileimagename];
        self.hasReadImgVw.image = [UIImage imageNamed:message.myFriend.profileimagename];
    }
    if(message.date != nil){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"h:mm a"];

        NSTimeInterval elapsedTimeInSeconds = [[NSDate date] timeIntervalSinceDate:message.date];
        NSTimeInterval secondsInDays = 60 * 60 * 24;

        if(elapsedTimeInSeconds > 7 * secondsInDays){
            [dateFormatter setDateFormat:@"MM/dd/yy"];
        }else if(elapsedTimeInSeconds > secondsInDays){
            [dateFormatter setDateFormat:@"EEE"];
        }
        
        self.timeLabel.text = [dateFormatter stringFromDate:message.date];
    }
}

-(void)setupViews{
    [super setupViews];
    
    [self.contentView addSubview:self.profileImgVw];
    [self.contentView addSubview:self.dividerLineVw];
    
    [self setupContainerView];
    
    [self.profileImgVw setImage:[UIImage imageNamed:@"stevejobs"]];
    [self.hasReadImgVw setImage:[UIImage imageNamed:@"stevejobs"]];
    
    [self addConstraintsWithFormat:@"H:|-12-[v0(60)]" withViews:self.profileImgVw, nil];
    [self addConstraintsWithFormat:@"V:[v0(60)]" withViews:self.profileImgVw, nil];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:self.profileImgVw attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [self addConstraintsWithFormat:@"H:|-82-[v0]|" withViews:self.dividerLineVw, nil];
    [self addConstraintsWithFormat:@"V:[v0(1)]|" withViews:self.dividerLineVw, nil];
}

-(void)setupContainerView{
    UIView *containerView = [[UIView alloc] init];
//    containerView.backgroundColor = [UIColor redColor];
    [self addSubview:containerView];
    
    [self addConstraintsWithFormat:@"H:|-90-[v0]|" withViews:containerView, nil];
    [self addConstraintsWithFormat:@"V:[v0(50)]" withViews:containerView, nil];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:containerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.contentView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [containerView addSubview:self.nameLabel];
    [containerView addSubview:self.messageLabel];
    [containerView addSubview:self.timeLabel];
    [containerView addSubview:self.hasReadImgVw];
    
    [containerView addConstraintsWithFormat:@"H:|[v0][v1(80)]-12-|" withViews:self.nameLabel, self.timeLabel, nil];
    [containerView addConstraintsWithFormat:@"V:|[v0][v1(24)]|" withViews:self.nameLabel, self.messageLabel, nil];
    [containerView addConstraintsWithFormat:@"H:|[v0]-8-[v1(20)]-12-|" withViews:self.messageLabel, self.hasReadImgVw, nil];
    [containerView addConstraintsWithFormat:@"V:|[v0(24)]|" withViews:self.timeLabel, nil];
    [containerView addConstraintsWithFormat:@"V:[v0(20)]|" withViews:self.hasReadImgVw, nil];
}

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
    
    self.contentView.backgroundColor = highlighted ? [UIColor colorWithRed:0 green:134/255 blue:245/255 alpha:1] : [UIColor whiteColor];
    self.nameLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
    self.timeLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
    self.messageLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor blackColor];
}

@end

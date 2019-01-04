//
//  ChatLogCell.m
//  ChattoSauce
//
//  Created by Drey Mill on 03/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "ChatLogCell.h"

@interface ChatLogCell()

@end

@implementation ChatLogCell

-(UITextView *)messageTextView{
    if(!_messageTextView){
        _messageTextView = [[UITextView alloc] init];
        _messageTextView.font = [UIFont systemFontOfSize:18];
        _messageTextView.text = @"Sample Message";
        _messageTextView.backgroundColor = [UIColor clearColor];
        _messageTextView.editable = false;
    }
    return _messageTextView;
}

-(UIView *)textBubbleView{
    if(!_textBubbleView){
        _textBubbleView = [[UIView alloc] init];
//        _textBubbleView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        _textBubbleView.layer.cornerRadius = 15;
        _textBubbleView.layer.masksToBounds = true;
    }
    return _textBubbleView;
}

-(UIImageView *)profileImageView{
    if(!_profileImageView){
        _profileImageView = [[UIImageView alloc] init];
        _profileImageView.contentMode = UIViewContentModeScaleAspectFill;
        _profileImageView.layer.cornerRadius = 15;
        _profileImageView.layer.masksToBounds = true;
    }
    return _profileImageView;
}

-(UIImageView *)bubbleImageView{
    if(!_bubbleImageView){
        _bubbleImageView = [[UIImageView alloc] init];
        _bubbleImageView.image = GRAYBUBBLEIMAGE;
        _bubbleImageView.tintColor = [UIColor colorWithWhite:0.90 alpha:1];
    }
    return _bubbleImageView;
}

-(void)setupViews{
    [super setupViews];
    
    [self.contentView addSubview:self.textBubbleView];
    [self.contentView addSubview:self.messageTextView];
    [self.contentView addSubview:self.profileImageView];
    
    [self addConstraintsWithFormat:@"H:|-8-[v0(30)]" withViews:self.profileImageView, nil];
    [self addConstraintsWithFormat:@"V:[v0(30)]|" withViews:self.profileImageView, nil];
    self.profileImageView.backgroundColor = [UIColor redColor];
    
    [self.textBubbleView addSubview:self.bubbleImageView];
    [self.textBubbleView addConstraintsWithFormat:@"H:|[v0]|" withViews:self.bubbleImageView, nil];
    [self.textBubbleView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.bubbleImageView, nil];
}

@end

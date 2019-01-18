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

-(CachedImageView *)messageImageView{
    if(!_messageImageView){
        _messageImageView = [[CachedImageView alloc] init];
        _messageImageView.layer.cornerRadius = 16;
        _messageImageView.layer.masksToBounds = true;
        _messageImageView.contentMode = UIViewContentModeScaleAspectFill;
        _messageImageView.backgroundColor = [UIColor blackColor];
        _messageImageView.userInteractionEnabled = true;
        
        UITapGestureRecognizer *tapImage = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomTap:)];
        [_messageImageView addGestureRecognizer:tapImage];
    }
    return _messageImageView;
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

-(CachedImageView *)profileImageView{
    if(!_profileImageView){
        _profileImageView = [[CachedImageView alloc] init];
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

-(void)handleZoomTap:(UITapGestureRecognizer *)tapGesture{
    if([tapGesture.view isKindOfClass:UIImageView.class]){
        UIImageView *zoominImageView = (UIImageView *)tapGesture.view;
        if(zoominImageView.image == nil){
            return;
        }
        if(CGSizeEqualToSize(zoominImageView.image.size, CGSizeZero)){
            return;
        }
        [self.chatLogController performZoomInStartingImageView: zoominImageView];
    }
}

-(void)setupViews{
    [super setupViews];
    
    [self.contentView addSubview:self.textBubbleView];
    [self.contentView addSubview:self.messageTextView];
    [self.contentView addSubview:self.profileImageView];
    
    self.profileImageView.image = [UIImage imageNamed:@"avatar"];
    
    [self addConstraintsWithFormat:@"H:|-8-[v0(30)]" withViews:self.profileImageView, nil];
    [self addConstraintsWithFormat:@"V:[v0(30)]|" withViews:self.profileImageView, nil];
    
    [self.textBubbleView addSubview:self.bubbleImageView];
    [self.textBubbleView addConstraintsWithFormat:@"H:|[v0]|" withViews:self.bubbleImageView, nil];
    [self.textBubbleView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.bubbleImageView, nil];
    
    [self.textBubbleView addSubview:self.messageImageView];
    [self.textBubbleView addConstraintsWithFormat:@"H:|[v0]|" withViews:self.messageImageView, nil];
    [self.textBubbleView addConstraintsWithFormat:@"V:|[v0]|" withViews:self.messageImageView, nil];
    
}

@end

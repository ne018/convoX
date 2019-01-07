//
//  ChatLogCell.h
//  ChattoSauce
//
//  Created by Drey Mill on 03/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "BaseCell.h"
#import <UIKit/UIKit.h>

// define macros
#define GRAYBUBBLEIMAGE [[[UIImage imageNamed:@"bubble_gray"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 26, 22, 26)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
#define BLUEBUBBLEIMAGE [[[UIImage imageNamed:@"bubble_blue"] resizableImageWithCapInsets:UIEdgeInsetsMake(22, 26, 22, 26)] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];

NS_ASSUME_NONNULL_BEGIN

@interface ChatLogCell : BaseCell

@property (nonatomic, strong) UITextView *messageTextView;
@property (nonatomic, strong) UIView *textBubbleView;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UIImageView *bubbleImageView;


@end

NS_ASSUME_NONNULL_END

//
//  CachedImageView.h
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CachedImageView : UIImageView

typedef void(^tapCallBack)(void);
@property (nonatomic, copy) tapCallBack tapBlock;
@property (nonatomic, strong) NSCache *imageCache;
@property (nonatomic, assign) BOOL shouldUseEmptyImage;

-(void)loadImageWithUrlString:(NSString *)urlString withPlaceholder:(NSString *)placeholder completion:(void(^)(void))completion;


@end

NS_ASSUME_NONNULL_END

//
//  DiscardableImageCacheItem.h
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DiscardableImageCacheItem : NSObject<NSDiscardableContent>

@property (nonatomic, strong) UIImage *image;
@property (nonatomic) NSUInteger accessCount;

+(id)initializeWithUIImage:(UIImage *)image;
+(DiscardableImageCacheItem *)init:(UIImage *)image;
-(BOOL)beginContentAccess;


@end

NS_ASSUME_NONNULL_END

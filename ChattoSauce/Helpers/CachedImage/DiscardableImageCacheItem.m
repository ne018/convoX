//
//  DiscardableImageCacheItem.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "DiscardableImageCacheItem.h"

@implementation DiscardableImageCacheItem

+(id)initializeWithUIImage:(UIImage *)image {
    DiscardableImageCacheItem *discardable = [[DiscardableImageCacheItem alloc] init];
    discardable.image = image;
    return discardable;
}

/*+(DiscardableImageCacheItem *)init:(UIImage *)image {
 DiscardableImageCacheItem *discardable = [[DiscardableImageCacheItem alloc] init];
 discardable.image = image;
 return discardable;
 }*/

- (BOOL)beginContentAccess {
    if(self.image == nil){
        return false;
    }
    self.accessCount += 1;
    return true;
}

- (void)endContentAccess {
    if(self.accessCount > 0){
        self.accessCount -= 1;
    }
}

- (void)discardContentIfPossible {
    if(self.accessCount == 0){
        self.image = nil;
    }
}

- (BOOL)isContentDiscarded {
    return self.image == nil;
}


@end

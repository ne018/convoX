//
//  CacheController.h
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CacheController : NSObject{
    NSCache *cache;
}

@property (retain, nonatomic) NSCache *cache;

+(CacheController *)sharedInstance;
+(void)destroySharedInstance;

-(void)setCache:(id)obj forKey:(NSString *)key;
-(id)getCacheForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END

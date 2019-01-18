//
//  Message.h
//  ChattoSauce
//
//  Created by Drey Mill on 19/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Friend.h"
#import "Firebase.h"

NS_ASSUME_NONNULL_BEGIN


@interface Message : NSObject

@property (nonatomic, strong) NSString *messageid;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *type;

//@property (nonatomic, strong) NSNumber *isSender;
//@property (nonatomic, strong) NSString *fkfriendid;

@property (nonatomic, strong) NSString *fromuniqueid;
@property (nonatomic, strong) NSString *touniqueid;
@property (nonatomic, strong) NSString *imageUrl;
@property (nonatomic, strong) NSNumber *imageWidth;
@property (nonatomic, strong) NSNumber *imageHeight;

@property (nonatomic, strong) Friend *myFriend;
@property (nonatomic) NSDictionary *dictForm;

- (instancetype)initWithDictionary:(NSDictionary *)dict;
-(NSString *)chatPartnerId;

@end

NS_ASSUME_NONNULL_END

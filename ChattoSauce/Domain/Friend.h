//
//  Friend.h
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Friend : NSObject

@property (nonatomic, strong) NSString *friendid;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *profileimagename;

@property (nonatomic, strong) NSSet *messages;

@property (nonatomic) NSDictionary *dictForm;

-(instancetype)initWithName:(NSString *)name email:(NSString *)email profileimagename:(NSString *)profileimagename;
-(instancetype)initWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

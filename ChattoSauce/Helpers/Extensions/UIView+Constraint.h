//
//  UIView+Constraint.h
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Constraint)

-(void)addConstraintsWithFormat:(NSString *)format withViews:(UIView *)views, ...;

@end

NS_ASSUME_NONNULL_END

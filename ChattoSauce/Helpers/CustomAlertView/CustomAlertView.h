//
//  CustomAlertView.h
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CustomAlertView : NSObject<UITextFieldDelegate>

+ (void)csAlertView:(UIViewController *)controllerContext withTitle:(NSString *)title withMessage:(NSString *)message;

+ (void)csAlertView:(UIViewController *)controllerContext withStyle:(UIAlertControllerStyle)controllerStyle withTitle:(NSString *)title withMessage:(NSString *)message withButtons:(NSArray *)buttons withCompletion:(void(^)(NSString *actionType))completion;

+ (void)csAlertView:(UIViewController *)controllerContext withStyle:(UIAlertControllerStyle)controllerStyle withTitle:(NSString *)title withMessage:(NSString *)message withButtons:(NSArray *)buttons withParentView:(id)parentView withChildView:(id)childView withCompletion:(void(^)(NSString *actionType))completion;

+ (void)csAlertView:(UIViewController *)controllerContext withDelegate:(id)delegate withTitle:(NSString *)title withPlaceHolder:(NSString *)placeholder withTextValue:(NSString *)textValue withAttributeTitle:(BOOL)isAttributeTitle withCompletion:(void(^)(NSString *textFieldString))completion;


@end

NS_ASSUME_NONNULL_END

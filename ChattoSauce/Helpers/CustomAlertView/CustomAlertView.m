//
//  CustomAlertView.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "CustomAlertView.h"

@implementation CustomAlertView

+ (void)csAlertView:(UIViewController *)controllerContext withTitle:(NSString *)title withMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor colorWithRed:0.70 green:0.05 blue:0.31 alpha:1.0];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:ok];
    [controllerContext presentViewController:alertController animated:YES completion:nil];
}

+ (void)csAlertView:(UIViewController *)controllerContext withStyle:(UIAlertControllerStyle)controllerStyle withTitle:(NSString *)title withMessage:(NSString *)message withButtons:(NSArray *)buttons withCompletion:(void(^)(NSString *actionType))completion{
    UIAlertController *alertController = nil;
    if(controllerStyle == UIAlertControllerStyleActionSheet) {
        alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:controllerStyle];
    }
    if(controllerStyle == UIAlertControllerStyleAlert) {
        alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:controllerStyle];
    }
    //    alertController.view.tintColor = [UIColor colorWithRed:0.70 green:0.05 blue:0.31 alpha:1.0];
    
    for(NSInteger i = 0;i < buttons.count;i++) {
        NSString *buttonName = [buttons objectAtIndex:i];
        UIAlertAction *actions = nil;
        if([buttonName isEqualToString:@"cancel"]) {
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        } else if([buttonName isEqualToString:@"Keep Editing"]) {
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        } else if([buttonName isEqualToString:@"settings"]){
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        } else {
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        }
        [alertController addAction:actions];
    }
    [controllerContext presentViewController:alertController animated:YES completion:nil];
}

+ (void)csAlertView:(UIViewController *)controllerContext withStyle:(UIAlertControllerStyle)controllerStyle withTitle:(NSString *)title withMessage:(NSString *)message withButtons:(NSArray *)buttons withParentView:(id)parentView withChildView:(id)childView withCompletion:(void(^)(NSString *actionType))completion {
    UIAlertController *alertController = nil;
    if(controllerStyle == UIAlertControllerStyleActionSheet) {
        alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:controllerStyle];
    }
    if(controllerStyle == UIAlertControllerStyleAlert) {
        alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(title, @"") message:NSLocalizedString(message, @"") preferredStyle:controllerStyle];
    }
    
    alertController.view.tintColor = [UIColor colorWithRed:0.70 green:0.05 blue:0.31 alpha:1.0];
    
    for(NSInteger i = 0;i < buttons.count;i++) {
        NSString *buttonName = [buttons objectAtIndex:i];
        UIAlertAction *actions = nil;
        if([buttonName isEqualToString:@"cancel"]) {
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        } else {
            actions = [UIAlertAction actionWithTitle:NSLocalizedString([buttonName capitalizedString], @"") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                completion(buttonName);
            }];
        }
        
        [alertController addAction:actions];
    }
    
    NSLog(@"alertsize: %f", alertController.view.frame.size.width);
    UIView *contentView = (UIView *)parentView;
    
    CGRect cv = contentView.frame;
    cv.size.width = alertController.view.frame.size.width - 20;
    contentView.frame = cv;
    
    UIPickerView *pickerView = (UIPickerView *)childView;
    CGRect pv = pickerView.frame;
    pv.size.width = alertController.view.frame.size.width - 20;
    pickerView.frame = pv;
    
    [contentView addSubview:pickerView];
    
    if(parentView != nil && childView != nil) [alertController.view addSubview:contentView];
    
    [controllerContext presentViewController:alertController animated:YES completion:^{
        NSLog(@"alertsize: %f", alertController.view.frame.size.width);
    }];
}

+ (void)csAlertView:(UIViewController *)controllerContext withDelegate:(id)delegate withTitle:(NSString *)title withPlaceHolder:(NSString *)placeholder withTextValue:(NSString *)textValue withAttributeTitle:(BOOL)isAttributeTitle withCompletion:(void(^)(NSString *textFieldString))completion {
    
    NSString *alertTitle = NSLocalizedString(title, @"");
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:alertTitle message:nil preferredStyle:UIAlertControllerStyleAlert];
    alertController.view.tintColor = [UIColor colorWithRed:0.70 green:0.05 blue:0.31 alpha:1.0];
    
    NSMutableAttributedString *attributedTitle = [self setAttributeTitle:alertTitle withFontStyle:@"SFUIText-Regular" withColor:[UIColor colorWithRed:0.70 green:0.05 blue:0.31 alpha:1.0] withFontSize:15.0f];
    if(isAttributeTitle) {
        [alertController setValue:attributedTitle forKey:@"attributedTitle"];
    }
    
    void (^textField)(UITextField *) = ^(UITextField *textField) {
        if(textValue.length > 0)textField.text = textValue;
        textField.placeholder = NSLocalizedString(placeholder, @"");
        textField.font = [UIFont fontWithName:@"SFUIText-Regular" size:15.0f];
        textField.textColor = [UIColor blackColor];
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.borderStyle = UITextBorderStyleNone;
        textField.delegate = delegate;
        textField.keyboardType = UIKeyboardTypeDefault;
    };
    
    [alertController addTextFieldWithConfigurationHandler:textField];
    
    void (^saveHandler)(UIAlertAction *) = ^(UIAlertAction *alert) {
        NSString *textFieldValue = alertController.textFields[0].text;
        completion(textFieldValue);
    };
    
    void (^cancelHandler)(UIAlertAction *) = ^(UIAlertAction *alertAction) {
        [controllerContext dismissViewControllerAnimated:YES completion:nil];
    };
    
    UIAlertAction *ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", @"") style:UIAlertActionStyleDefault handler:saveHandler];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"") style:UIAlertActionStyleCancel handler:cancelHandler];
    
    [alertController addAction:ok];
    [alertController addAction:cancel];
    [controllerContext presentViewController:alertController animated:YES completion:nil];
}

+ (NSMutableAttributedString *)setAttributeTitle:(NSString *)title withFontStyle:(NSString *)fontstyle withColor:(UIColor *)color withFontSize:(CGFloat)size{
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:title];
    [attributedTitle addAttribute:NSFontAttributeName
                            value:[UIFont fontWithName:fontstyle size:size]
                            range:NSMakeRange(0, title.length)];
    [attributedTitle addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, title.length)];
    return attributedTitle;
}

@end

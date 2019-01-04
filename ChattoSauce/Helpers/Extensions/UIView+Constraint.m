//
//  UIView+Constraint.m
//  ChattoSauce
//
//  Created by Drey Mill on 18/12/2018.
//  Copyright © 2018 iOSHive. All rights reserved.
//

#import "UIView+Constraint.h"

@implementation UIView (Constraint)

-(void)addConstraintsWithFormat:(NSString *)format withViews:(UIView *)views, ...{
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
    NSMutableArray *arguments = [[NSMutableArray alloc] init];
    NSUInteger index = 0;
    
    id eachObject;
    va_list argumentList;
    
    if(views){
        [arguments addObject:views];
        va_start(argumentList, views);
        while ((eachObject = va_arg(argumentList, id))) {
            [arguments addObject:eachObject];
        }
        va_end(argumentList);
    }
    
    if(arguments.count > 0){
        for (UIView *view in arguments) {
            [viewsDictionary setObject:view forKey:[NSString stringWithFormat:@"v%lu", (unsigned long)index]];
            index++;
            view.translatesAutoresizingMaskIntoConstraints = false;
        }
    }
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:viewsDictionary]];
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

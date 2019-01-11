//
//  CachedImageView.m
//  ChattoSauce
//
//  Created by Drey Mill on 09/01/2019.
//  Copyright © 2019 iOSHive. All rights reserved.
//

#import "CachedImageView.h"
#import "CacheController.h"
#import "DiscardableImageCacheItem.h"

@interface CachedImageView()

@property (nonatomic, strong) UIImage *emptyImage;
@property (nonatomic, strong) NSString *urlStringForChecking;

@end

@implementation CachedImageView

// Convenience initializer
- (id)init {
    self = [super init];
    self.shouldUseEmptyImage = YES;
    return self;
}

// Convenience initializer
- (id)initWithCornerRadius:(CGFloat *)cornerRadius tapCallBack:(tapCallBack)taphtaph {
    self = [self initWithCornerRadius:cornerRadius emptyImage:nil];
    if (self) {
        self.userInteractionEnabled = true;
        self.tapBlock = taphtaph;
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)]];
    }
    return self;
}

// Designated initializer
- (id)initWithCornerRadius:(CGFloat *)cornerRadius emptyImage:(UIImage *)emptyImg {
    self = [super initWithFrame:CGRectZero];
    if(self){
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = true;
        self.layer.cornerRadius = *(cornerRadius);
        self.emptyImage = emptyImg;
    }
    return self;
}

-(void)handleTap:(UITapGestureRecognizer *)recognizer{
    self.tapBlock();
    NSLog(@"i got tapped!");
}

-(void)loadImageWithUrlString:(NSString *)urlString withPlaceholder:(NSString *)placeholder completion:(void(^)(void))completion {
    __block UIImage *image = nil;
    
    self.urlStringForChecking = urlString;
    NSString *urlKey = urlString;
    
    if(placeholder.length > 0){
        self.emptyImage = [UIImage imageNamed:placeholder];
    }
    
    if([[CacheController sharedInstance] getCacheForKey:urlKey]){
        self.image = (UIImage *)[[CacheController sharedInstance] getCacheForKey:urlKey];
        completion();
        return;
    }
    
    NSURL *url = [NSURL URLWithString:urlString];
    if(urlString.length == 0 || [urlString isEqualToString:@""]){
        self.shouldUseEmptyImage = YES;
        if(self.shouldUseEmptyImage){
            self.image = self.emptyImage;
        }
        return;
    }
    
    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if(error != nil){
            NSLog(@"error in ImageDL: %@ , url: %@", error, urlString);
            return;
        }
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if([UIImage imageWithData:data]){
                image = [UIImage imageWithData:data];
                //                DiscardableImageCacheItem *cacheItem = [DiscardableImageCacheItem initializeWithUIImage:image];
                [[CacheController sharedInstance] setCache:image forKey:urlKey];
                
                if([urlString isEqualToString:weakSelf.urlStringForChecking]){
                    weakSelf.image = image;
                    completion();
                }
            }
        });
    }] resume];
    
}


@end

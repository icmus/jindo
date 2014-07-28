//
//  ICMAutoresizedImageView.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMAutoresizedImageView.h"
#import "ICMConstants.h"

@implementation ICMAutoresizedImageView

- (void)setImage:(UIImage*)image{
    [super setImage:image];
    self.bounds = CGRectMake(0, 0, image.size.width, image.size.height);
    self.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    //self.contentMode = UIViewContentModeTopRight;
    if(DEBUGMODE){
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.2];
    }
}

@end

//
//  ICMNotificationProxy.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/3/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMNotificationProxy.h"
#import "ICMConstants.h"

@implementation ICMNotificationProxy

+ (void)notify:(NSString*)type withData:(NSDictionary*)data
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:type object:self userInfo:(NSDictionary *)data];

}

@end

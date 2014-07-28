//
//  ICMNotificationProxy.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/3/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMNotificationProxy : NSObject

+ (void)notify:(NSString*)type withData:(NSDictionary*)data;

@end

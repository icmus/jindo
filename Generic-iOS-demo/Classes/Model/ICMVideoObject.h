//
//  ICMVideoObject.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMVideoObject : NSObject

@property (strong, nonatomic) NSString* vidId;
@property (strong, nonatomic) NSString* uri;
@property (strong, nonatomic) NSString* hascontrols;
@property (strong, nonatomic) NSString* orientation;

@end

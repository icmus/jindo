//
//  ICMButtonObject.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMButtonObject : NSObject

@property (strong,nonatomic)NSString* backgroundAssetPath;
@property (strong,nonatomic)NSString* backgroundAssetType;

@property (strong,nonatomic)NSString* target;

@property (strong,nonatomic)NSNumber* xpos;
@property (strong,nonatomic)NSNumber* ypos;
@property (strong,nonatomic)NSNumber* width;
@property (strong,nonatomic)NSNumber* height;

@property (strong,nonatomic)NSArray* targetOptions;

@end

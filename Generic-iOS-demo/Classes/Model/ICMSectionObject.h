//
//  ICMSectionObject.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ICMSectionObject : NSObject

@property NSString  *sectionId;
@property NSString  *sectionType;
@property NSString  *backgroundAssetPath;

@property NSString  *oncomplete;
@property NSString  *video;

@property NSArray   *buttons;
@property NSString  *label;
@property BOOL      inNav;

@end

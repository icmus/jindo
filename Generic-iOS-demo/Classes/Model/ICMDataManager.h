//
//  ICMDataManager.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ICMSectionObject.h"
#import "ICMVideoObject.h"
#import "ICMSequenceObject.h"
#import "ICMButtonObject.h"
#import "ICMNavObject.h"
#import "ICMButtonType.h"

@interface ICMDataManager : NSObject

// for singleton use
+ (ICMDataManager*) sharedDataManager;
- (void)start;

// returns list of section ids
-(NSMutableArray*) getSectionList;

// returns all section objects 
-(NSMutableArray*) getAllSections;

//returns a single section object
-(ICMSectionObject*) getSectionObjectById:( NSString *) sectionId;

//returns array of button objects
-(NSMutableArray*) getButtonsBySectionId:( NSString *) sectionId;

//returns global nav elements
- (NSMutableArray*) getGlobalNavObjects;

//returns a single sequence object
-(ICMSequenceObject*) getSequenceObjectById:( NSString *) seqId;

//returns a single video object
-(ICMVideoObject*) getVideoObjById:( NSString *) vidID;

//inserts uiimage from id into view
-(void)getImageById:(NSString*)imgId forView:(UIImageView*)imgView;

@end

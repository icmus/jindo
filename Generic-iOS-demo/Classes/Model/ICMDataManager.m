//
//  ICMDataManager.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMDataManager.h"
#import "ICMConstants.h"

@interface ICMDataManager()

@property NSMutableArray* sections;
@property NSMutableArray* videos;
@property NSMutableArray* images;
@property NSMutableDictionary* buttonTypes;
@property NSMutableArray* nav;

@end

@implementation ICMDataManager

static ICMDataManager *sharedDataManager;

@synthesize sections = sections_;
@synthesize videos = videos_;
@synthesize images = images_;
@synthesize buttonTypes = buttonTypes_;
@synthesize nav = nav_;

+ (void)initialize {
    NSLog(@"ICMDataManager initialize");
    NSAssert(self == [ICMDataManager class], @"ICMDataManager is not intended to be subclassed.");
    sharedDataManager = [ICMDataManager new];
}

+ (ICMDataManager *)sharedDataManager {
    return sharedDataManager;
}

- (id) init {
    self = [super init];
    if (self) {
       NSLog(@"ICMDataManager init");
    }
    return self;
}


- (void)start {
    NSLog(@"ICMDataManager start");
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"json"];
    NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    [self cacheJSONData:fileContent];
}


- (void) cacheJSONData:(NSString *)fileContent {
     NSLog(@"ICMDataManager cacheJSONData");
    //NSDate *startTime = [NSDate date];
    
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData: [fileContent dataUsingEncoding:NSUTF8StringEncoding] options: NSJSONReadingMutableContainers error: &error];
    //CHECK FOR ERROR
    if (error) {
        NSLog(@"error parsing JSON file.");
        return;
    }
   
    // format objects
    
    //global
    
    //config
    //TODO
    
    
    
    //button types
    buttonTypes_ = [[NSMutableDictionary alloc] init];
    NSArray* btnTypeSrc = [json objectForKey:@"buttons"];
    int l = [btnTypeSrc count];
    for (int i=0; i<l; i++) {
        NSDictionary* item = btnTypeSrc[i];
        ICMButtonType* obj = [[ICMButtonType alloc]init];
        
        obj.backgroundAssetPath = [item objectForKey:@"id"];
        obj.width = [item objectForKey:@"width"];
        obj.height = [item objectForKey:@"height"];
        
        [buttonTypes_ setObject:obj forKey:[item objectForKey:@"id"]];
    }
    //NSLog(@"cacheJSONData buttonTypes_ %@", buttonTypes_);

    
    
    // sections
    sections_ = [[NSMutableArray alloc] init];
    NSArray* sectionSrc = [json objectForKey:@"sections"];
    l = [sectionSrc count];
    
    for (int i=0; i<l; i++) {
        //
        NSDictionary* section = sectionSrc[i];
        
        ICMSectionObject* obj = [[ICMSectionObject alloc]init];
        
        //NSLog(@"sectionId %@",section);
        
        obj.sectionId = [section objectForKey:@"id"];
        obj.sectionType = [section objectForKey:@"type"];
        obj.label = [section objectForKey:@"label"];
        obj.backgroundAssetPath = [section objectForKey:@"backgroundAssetPath"];
        obj.inNav = ([[section objectForKey:@"inNav"]integerValue]==1)? true:false ;
        
        if([section objectForKey:@"video"]){
            obj.video = [section objectForKey:@"video"];
        }
        
        if([section objectForKey:@"oncomplete"]){
            obj.oncomplete = [section objectForKey:@"oncomplete"];
        }
        
        //add button objs
        NSArray* btnSrc = [section objectForKey:@"buttons"];
        NSMutableArray* buttons = [[NSMutableArray alloc] init];
        obj.buttons = buttons;
        
        for (int j=0; j<[btnSrc count]; j++) {
            
            ICMButtonObject* btnObj = [[ICMButtonObject alloc]init];
            
            NSDictionary* btn = btnSrc[j];
            
            //btnObj.backgroundAssetPath = [btn objectForKey:@"backgroundAssetPath"];
            //btnObj.backgroundAssetType = [btn objectForKey:@"backgroundAssetType"];
            btnObj.target = [btn objectForKey:@"target"];
            //btnObj.targetType = [btn objectForKey:@"targetType"];
            
            btnObj.xpos = [btn objectForKey:@"xpos"];
            btnObj.ypos = [btn objectForKey:@"ypos"];
            
            //get from type
            ICMButtonType *btnType = [buttonTypes_ objectForKey:[btn objectForKey:@"type"]];
            
            btnObj.width = btnType.width;
            btnObj.height = btnType.height;
            
            if ([btn objectForKey:@"targetOptions"]) {
                btnObj.targetOptions = [[NSArray alloc]initWithArray:[btn objectForKey:@"targetOptions"]];
            }
            
            [buttons addObject:btnObj];
        }
        [sections_ addObject:obj];
    }
    //NSLog(@"cacheJSONData sections %@", sections_);
    
    //format video objects
    videos_  = [[NSMutableArray alloc]init];
    NSArray* videoSrc = [json objectForKey:@"videos"];
    
    for (int i=0; i<[videoSrc count]; i++) {
        ICMVideoObject* obj = [[ICMVideoObject alloc]init];
        NSDictionary *src = videoSrc[i];
        obj.vidId = [src objectForKey:@"id"];
        obj.uri = [src objectForKey:@"uri"];
        obj.hascontrols = [src objectForKey:@"hascontrols"];
        obj.orientation = [src objectForKey:@"orientation"];
        [videos_ addObject:obj];
    }
    //NSLog(@"videos_: %@", videos_);
    
    
    //nav
    //check sections for inNav, if true add an obj here
    nav_ = [[NSMutableArray alloc] init];
    
    //NSArray* navSrc = [[json objectForKey:@"global"] objectForKey:@"nav"];
    
    l = [sections_ count];
    for (int i=0; i<l; i++) {
        
        ICMSectionObject* item = sections_[i];
        
        if(item.inNav){
            ICMNavObject* obj = [[ICMNavObject alloc]init];
            obj.label = item.label;
            obj.target = item.sectionId;
            [nav_ addObject:obj];
        }
    }
    
    
    //notify of completion
    json = nil;
    [[NSNotificationCenter defaultCenter] postNotificationName:MODEL_INIT_COMPLETE object:self userInfo:nil];
}

-(NSMutableArray*) getSectionList {
    NSMutableArray *result = [[NSMutableArray alloc]initWithCapacity:[sections_ count]];
    int l = [sections_ count];
    for (int i=0; i<l; i++) {
        ICMSectionObject* obj = sections_[i];
        [result addObject:obj.sectionId];
    }
    //NSLog(@"getSectionList: %@",result);
    return result;
}

// returns all section objects
-(NSMutableArray*) getAllSections {
    return sections_;
}

//returns a single section object
-(ICMSectionObject*) getSectionObjectById:( NSString *) sectionId {
    ICMSectionObject* result = nil;
    int l = [sections_ count];
    for (int i=0; i<l; i++) {
        
        ICMSectionObject* obj = sections_[i];
        //NSLog(@"getSectionObjectById, obj:%@",obj.sectionId);
        if([obj.sectionId isEqualToString:sectionId]){
            result = obj;
            break;
        }
    }
    if(result==nil)NSLog(@"getSectionObjectById failed, result is nil. id:%@",sectionId);
    return result;
}

//returns array of button objects
-(NSMutableArray*) getButtonsBySectionId:( NSString *) sectionID {
    NSMutableArray* result = nil;
    return result;
}

//returns a single sequence object
-(ICMSequenceObject*) getSequenceObjectById:( NSString *) seqID {
    ICMSequenceObject* result = nil;
    return result;
}

//returns a single video object
-(ICMVideoObject*) getVideoObjById:( NSString *) vidID {
    ICMVideoObject* result = nil;
    int l = [videos_ count];
    
    for (int i=0; i<l; i++) {
        ICMVideoObject* obj = videos_[i];
        if([obj.vidId isEqualToString:vidID]){
            result = obj;
            break;
        }
    }
    if(result==nil)NSLog(@"getVideoObjById failed, result is nil. id:%@",vidID);
    return result;
}

-(void)getImageById:(NSString*)imgId forView:(UIImageView*)imgView {
    UIImage* img = [UIImage imageNamed:imgId];
    if(img){
        imgView.image = img;
    }else{
        NSLog(@"image not found");
        //TODO add place holder image here
    }
}

- (NSMutableArray*) getGlobalNavObjects {
    return nav_;
}

@end

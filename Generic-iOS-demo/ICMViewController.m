//
//  ICMViewController.m
//
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMViewController.h"
#import "ICMDataManager.h"
#import "ICMAbstractViewController.h"
#import "ICMQRcodeReaderViewController.h"
#import "ICMSimpleSegue.h"
#import "ICMConstants.h"
#import "ICMSectionObject.h"
#import "ICMVideoPlayerViewController.h"
#import "ICMNavViewController.h"

@interface ICMViewController ()

@property (strong, nonatomic) ICMDataManager *sharedDataManager;
@property (strong, nonatomic) NSString *vcID;
@property (strong, nonatomic) UIStoryboard *aStoryboard;
@property (strong, nonatomic) NSMutableDictionary *childControllers;
@property (strong, nonatomic) UIView *mainContainer;
@property (strong, nonatomic) ICMVideoPlayerViewController *videoPlayer_;
@property (strong, nonatomic) ICMNavViewController *globalNav;


@end

@implementation ICMViewController

@synthesize vcID = vcID_;
@synthesize sharedDataManager = sharedDataManager_;
@synthesize aStoryboard = aStoryboard_;
@synthesize childControllers = childControllers_;
@synthesize mainContainer = mainContainer_;
@synthesize videoPlayer_ = videoPlayer_;
@synthesize globalNav = globalNav_;


- (void)viewDidAppear:(BOOL)animated {
    //NSLog(@"boolForKey:@'debug_mode': %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"debug_mode"]);
    //DEBUGMODE = [[NSUserDefaults standardUserDefaults] boolForKey:@"debug_mode"];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSLog(@"ICMViewController viewDidLoad");
    //NSLog(@"boolForKey:@'debug_mode': %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"debug_mode"]);
    //DEBUGMODE = [[NSUserDefaults standardUserDefaults] boolForKey:@"debug_mode"];
    //DEBUGMODE = YES;
    
    //set-up root view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    //set-up view container for all child view controllers
    mainContainer_ = [[UIView alloc] initWithFrame:CGRectInset(self.view.bounds, 0,0)];
    mainContainer_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:mainContainer_];
    
    //data ready
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(build:) name:MODEL_INIT_COMPLETE object:nil];
    
    //listen for navigation request
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(navigateRequest:) name:NAVIGATE_REQUEST object:nil];
    
    
    [[ICMDataManager sharedDataManager]start];
}

#pragma mark -
#pragma mark noticaion handlers

- (void)build:(NSNotification *)notification {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MODEL_INIT_COMPLETE object:nil];
    
    //not crazy about this setup to call first section, but you can't use segue with less than 2 viewControllers
    vcID_ = [[ICMDataManager sharedDataManager]getSectionList][0];
    
    aStoryboard_ = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:[NSBundle mainBundle]];
    ICMSectionObject *obj = [[ICMDataManager sharedDataManager]getSectionObjectById:vcID_];
    
    childControllers_ = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                         [aStoryboard_ instantiateViewControllerWithIdentifier:obj.sectionType], vcID_,
                         nil];
    
    ICMAbstractViewController *controller = (ICMAbstractViewController *)[childControllers_ objectForKey:vcID_];
    [self addChildViewController:controller];
    
    controller.view.frame = mainContainer_.bounds;
    controller.view.autoresizingMask = mainContainer_.autoresizingMask;
    
    [controller dataForSegue:[NSDictionary dictionaryWithObject:obj forKey:@"sectionObj"]];
    controller.view.alpha=0;
    
    [mainContainer_ addSubview:controller.view];
    [controller showView];
}

- (void)navigateRequest:(NSNotification *)val {
    
    [self switchToView:val];
}


#pragma mark -
#pragma mark segue management

- (NSString *)getCurrentSection {
    return vcID_;
}


- (void)switchToView:(NSNotification *)val {
    
    NSLog(@"current vcID_: %@ \n\n",vcID_);
    
    //get the requested view controller name
    NSString *name = [[val userInfo] objectForKey:@"StoryboardID"];
    
    //kicks out if receives call to the active id
    if([name isEqualToString:vcID_])return;
    
    //was there any data sent along with the request?
    NSMutableDictionary *data;
    if ([val userInfo] != nil) {
        data  = [[val userInfo] mutableCopy];
    } else {
        data = [[NSMutableDictionary alloc] init];
    }
    
    ICMSectionObject *obj = [[ICMDataManager sharedDataManager]getSectionObjectById:[data objectForKey:@"StoryboardID" ]];
    NSString* requestType = obj.sectionType;
    
    ICMAbstractViewController *dst = nil;
    dst = (ICMAbstractViewController *)[aStoryboard_ instantiateViewControllerWithIdentifier:requestType];
    [childControllers_ setObject:dst forKey:name];
    [self addChildViewController:dst];
    
    ICMAbstractViewController *src = (ICMAbstractViewController *)[childControllers_ objectForKey:vcID_];
    [dst dataForSegue:[NSDictionary dictionaryWithObject:obj forKey:@"sectionObj"]];
    
    ICMSimpleSegue *segue = [[ICMSimpleSegue alloc] initWithIdentifier:@"segue" source:src destination:dst];
    segue.delegate = self;
    [segue perform];
    
    vcID_ = name;
    NSLog(@"new vcID_: %@ \n\n",vcID_);
}


- (void)unloadChildViewController:(ICMAbstractViewController *)vc {
    
    NSArray *keys = [childControllers_ allKeysForObject:vc];
    for (int i=0;i<keys.count;i++) {
        [childControllers_ removeObjectForKey:[keys objectAtIndex:i]];
    }
    [vc.view removeFromSuperview];
    vc = nil;
    NSLog(@"unloadChildViewController %@",vc);
}


- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

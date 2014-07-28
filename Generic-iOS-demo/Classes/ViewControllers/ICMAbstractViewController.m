//
//  ICMAbstractViewController.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMAbstractViewController.h"
#import "ICMDataManager.h"
#import "ICMSectionObject.h"
#import "ICMButtonObject.h"
#import "ICMGenericButton.h"
#import "ICMConstants.h"
#import "ICMAutoresizedImageView.h"

@interface ICMAbstractViewController ()

@end

@implementation ICMAbstractViewController

@synthesize dataObj = dataObj_;
@synthesize buttons = buttons_;
@synthesize vcname = vcname_;
@synthesize bgImage = bgImage_;
@synthesize sectionLabel = sectionLabel_;


- (void)dataForSegue:(NSDictionary *)data {
    //this is called by the view controller container prior to the segue being performed
    dataObj_ = [data objectForKey:@"sectionObj"];
    //NSLog(@"ICMAbstractViewController dataForSegue: %@",dataObj_);
    [self build];
}


-(void)build {
    // get background from data
    NSLog(@"ICMAbstractViewController build");
        
    bgImage_ = [[ICMAutoresizedImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    [self.view addSubview:bgImage_];
    
    [[ICMDataManager sharedDataManager]getImageById:dataObj_.backgroundAssetPath
                                            forView:bgImage_];
    
    // create buttons from data
    buttons_ = [[NSMutableArray alloc]init];
    
    int l = [dataObj_.buttons count];
    for (int i=0; i<l; i++) {
        
        ICMButtonObject* btnObj = dataObj_.buttons[i];
        //NSLog(@"ICMAbstractViewController build: %@",btnObj);
        
        ICMGenericButton *btn = [[ICMGenericButton alloc]
                                 initWithFrame:CGRectMake([btnObj.xpos intValue], [btnObj.ypos intValue],
                                                          [btnObj.width intValue], [btnObj.height intValue])];

        btn.dataObj = btnObj;
        [btn setMode:DEBUGMODE];
        
        [self.view addSubview:btn];
        [btn addTarget:self action:@selector(onSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        [buttons_ addObject:btn];
    }
}

- (void)debugModeChange:(NSNotification *)val {
    
    NSLog(@"\n\nICMAbstractViewController debugModeChange \n\n");
    [self buttonLoop];
}

-(IBAction)onSelectItem:(ICMGenericButton*)sender {
    
    //TODO add optional button click sound
    
    //NSLog(@"ICMAbstractViewController onSelectItem, target: %@", sender.dataObj.target);
    NSString* target = sender.dataObj.target;
    
    if ([sender.dataObj.target isEqualToString:@"randomSection"]) {
        target = [sender.dataObj.targetOptions objectAtIndex: arc4random() % [sender.dataObj.targetOptions count]];
        
    }else if([sender.dataObj.target rangeOfString:@"http"].location!=NSNotFound){
        // if link need to handle this
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:target]];
        return;
    }
    
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NAVIGATE_REQUEST object:self
     userInfo:(NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:   target ,@"StoryboardID",
                                                                            sender.dataObj.targetOptions,@"targetOptions",
                                                                            nil]];
}


- (void)showView {
    if (self.view.alpha == 1) return;
    [self viewWillAppear:YES];
    self.view.hidden = NO;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished){
        [self viewDidAppear:YES];
    }];
}


- (void)hideView {
    if (self.view.alpha == 0) return;
    [self viewWillDisappear:YES];
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished){
        self.view.hidden = YES;
        [self viewDidDisappear:YES];
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"didReceiveMemoryWarning: %@",self.vcname);
}

-(void)viewWillAppear:(BOOL)animated {

    [self buttonLoop];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(debugModeChange:)
                                                            name:DEBUGMODECHANGE object:nil];
}

-(void) buttonLoop {
    NSLog(@"check buttons loop: %hhd",DEBUGMODE);
    int l = [buttons_ count];
    if( l < 0 ) return;
    
    for (int i = 0; i<l; i++) {
        
        ICMGenericButton *btn = buttons_[i];
        [btn setMode:DEBUGMODE];
    }
}

- (void)viewDidDisappear:(BOOL)animated{
    
    int l = [buttons_ count];
    if( l < 0 ) return;
    
    for (int i = 0; i<l; i++) {
        ICMGenericButton *btn = buttons_[i];
        [btn removeTarget:self action:@selector(onSelectItem:) forControlEvents:UIControlEventTouchUpInside];
        btn = nil;
    }
    
    bgImage_.image = nil;
    dataObj_ = nil;
    buttons_ = nil;
    vcname_ = nil;
    bgImage_ = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:DEBUGMODECHANGE object:nil];

}


// iOS6
- (BOOL)shouldAutorotate {
    return YES;
}
@end

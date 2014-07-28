//
//  ICMSimpleSegue.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/1/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMSimpleSegue.h"
#import "ICMAbstractViewController.h"

@interface ICMSimpleSegue()

@property (weak) NSDictionary *dataForSegue;

@end

@implementation ICMSimpleSegue

@synthesize delegate = delegate_;
@synthesize dataForSegue = dataForSegue_;

- (void)dataToSend:(NSDictionary *)dataForDestinationController {
    dataForSegue_ = dataForDestinationController;
}

- (void)perform {
    
    ICMAbstractViewController *src = (ICMAbstractViewController *)self.sourceViewController;
    ICMAbstractViewController *dst = (ICMAbstractViewController *)self.destinationViewController;
    
    dst.view.frame = delegate_.view.bounds;
    dst.view.autoresizingMask = delegate_.view.autoresizingMask;
    if (dataForSegue_) [dst dataForSegue:dataForSegue_];
    
    //[src willMoveToParentViewController:nil];
    
    [delegate_
     transitionFromViewController:src
     toViewController:dst
     duration:0.5f
     options:UIViewAnimationOptionTransitionCrossDissolve
     animations:^(void){}
     completion:^(BOOL finished) {
         [dst didMoveToParentViewController:delegate_];
         [src removeFromParentViewController];
         [delegate_ unloadChildViewController:src];
     }
     ];
}

@end

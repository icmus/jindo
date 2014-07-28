//
//  ICMViewController.h
//  Office_iOS_demo
//
//  Created by Geoff Gannon on 8/6/13.
//  Copyright (c) 2013 iconmobile LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICMAbstractViewController.h"

@interface ICMViewController : UIViewController

- (void)unloadChildViewController:(ICMAbstractViewController *)vc;

@end

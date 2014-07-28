//
//  ICMSimpleSegue.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/1/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICMViewController.h"

@interface ICMSimpleSegue : UIStoryboardSegue

@property (weak) ICMViewController *delegate;

- (void)dataToSend:(NSDictionary *)dataForDestinationController;

@end

//
//  ICMGenericButton.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/1/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICMButtonObject.h"

@interface ICMGenericButton : UIButton

@property (strong, nonatomic) ICMButtonObject* dataObj;

- (void) setMode:(BOOL)mode;

@end

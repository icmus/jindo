//
//  ICMAbstractViewController.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 4/30/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICMDataManager.h"
#import "ICMAutoresizedImageView.h"

@interface ICMAbstractViewController : UIViewController

@property (strong, nonatomic) NSString *vcname;
@property (strong,nonatomic) ICMSectionObject* dataObj;
@property (strong, nonatomic) NSMutableArray* buttons;
@property (strong, nonatomic) ICMAutoresizedImageView* bgImage;
@property (strong, nonatomic) IBOutlet UILabel* sectionLabel;

- (void) dataForSegue:(NSDictionary*)data;
- (void) build;
- (void) showView;
- (void) hideView;

@end

//
//  ICMNavViewController.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/10/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMAbstractViewController.h"

@interface ICMNavViewController : ICMAbstractViewController <UITableViewDataSource,UITableViewDelegate>

    @property (weak, nonatomic) IBOutlet UITableView *tableView;
    @property (weak, nonatomic) IBOutlet UISwitch *debugSwitch;

    - (IBAction)handleSwitchValueChange:(id)sender;

@end

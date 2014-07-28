//
//  ICMNavViewController.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/10/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMNavViewController.h"
#import "ICMDataManager.h"
#import "ICMNavObject.h"
#import "ICMConstants.h"

@interface ICMNavViewController ()

@property (strong, nonatomic) NSMutableArray* navData;

@end

@implementation ICMNavViewController

@synthesize navData = navData_;
@synthesize tableView = tableView_;

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"[navData_ count] %d",[navData_ count]);
    return [navData_ count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
    
    ICMNavObject *obj = [navData_ objectAtIndex: indexPath.row];
    cell.textLabel.text = obj.label;
    cell.textLabel.textColor = [UIColor grayColor];
    
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds] ;
    cell.selectedBackgroundView.backgroundColor = [UIColor darkGrayColor] ;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    NSLog(@"cellForRowAtIndexPath obj.label %@", obj.label);
    return cell;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    ICMNavObject *obj = [navData_ objectAtIndex:indexPath.row];
     NSLog(@"didSelectRowAtIndexPath: %@",obj);
    if(obj){
        [[NSNotificationCenter defaultCenter]
         postNotificationName:NAVIGATE_REQUEST object:self
         userInfo:(NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys: obj.target ,@"StoryboardID", nil]];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    navData_ = [[ICMDataManager sharedDataManager]getGlobalNavObjects];
    NSLog(@"navData_: %@",navData_);
    [self.tableView sizeToFit];
}


- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}

- (IBAction)handleSwitchValueChange:(id)sender {
}
@end

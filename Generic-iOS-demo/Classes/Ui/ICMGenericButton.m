//
//  ICMGenericButton.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/1/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMGenericButton.h"
#import "ICMConstants.h"

@implementation ICMGenericButton

//@synthesize target;
//@synthesize targetType;
@synthesize dataObj;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

-(void) setMode:(BOOL) mode {
    
    if(mode){
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.7f];
        [self setTitle:dataObj.target forState:UIControlStateNormal];
    }else{
        self.backgroundColor = [UIColor clearColor];
        [self setTitle:@"" forState:UIControlStateNormal];
    }
}

@end

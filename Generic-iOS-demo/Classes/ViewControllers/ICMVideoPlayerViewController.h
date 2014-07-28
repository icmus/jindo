//
//  ICMVideoPlayerViewController.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/3/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ICMAbstractViewController.h"

@interface ICMVideoPlayerViewController : ICMAbstractViewController

- (void)playVideo:(NSString *)uri;

@end

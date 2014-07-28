//
//  ICMVideoPlayerViewController.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/3/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//
#import "ICMAbstractViewController.h"
#import "ICMVideoPlayerViewController.h"
#import "ICMDataManager.h"
#import "ICMConstants.h"
#import "ICMVideoObject.h"

@interface ICMVideoPlayerViewController ()

@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property (strong, nonatomic) NSString *videoURI;
@property (weak) NSString *returnToViewController;
@property (strong, nonatomic) ICMVideoObject* vidObj;

@end

@implementation ICMVideoPlayerViewController

@synthesize moviePlayer = moviePlayer_;
@synthesize videoURI = videoURI_;
@synthesize returnToViewController = returnToViewController_;
@synthesize vidObj = vidObj_;


- (void)viewDidLoad {
    [super viewDidLoad];
	self.vcname = @"video player";
    
    self.view.backgroundColor = [UIColor clearColor];
     NSLog(@"ICMVideoPlayerViewController viewDidLoad");
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    
}

-(void)build {
    [super build];
    
    //get video obj
    vidObj_ =[[ICMDataManager sharedDataManager] getVideoObjById:self.dataObj.video];
    [self playVideo:vidObj_.uri];
}

- (void)playVideo:(NSString *)uri {
    NSLog(@"ICMVideoPlayerViewController playVideo uri: %@",uri);
    
    NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:uri ofType:@"mp4"]];
    
    if (moviePlayer_==nil) {
        
        NSLog(@"moviePlayer is nil, create one");
        moviePlayer_ = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
        moviePlayer_.movieSourceType = MPMovieSourceTypeFile;
        moviePlayer_.shouldAutoplay = YES;
        moviePlayer_.fullscreen = YES;
        moviePlayer_.view.alpha = 0;
        [moviePlayer_ prepareToPlay];
    } else {
        moviePlayer_.contentURL = url;
        [moviePlayer_ prepareToPlay];
    }
    
    if([vidObj_.orientation isEqualToString:@"landscape"]){
        
        UIView * playerView = [moviePlayer_ view];
        [playerView setFrame: CGRectMake(0, 0, 620, 320)];
    
        CGAffineTransform landscapeTransform;
        landscapeTransform = CGAffineTransformMakeRotation(90*M_PI/180.0f);
        landscapeTransform = CGAffineTransformTranslate(landscapeTransform, 80, 80);
    
        [playerView setTransform: landscapeTransform];
    }
    
    if ([vidObj_.hascontrols isEqualToString:@"true"]) {
        [moviePlayer_ setControlStyle:MPMovieControlStyleDefault];
    }else{
        [moviePlayer_ setControlStyle:MPMovieControlStyleNone];
    }
    
    //add listners for load and complete
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayBackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerLoadStateDidChange:) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    
}


- (void)moviePlayerLoadStateDidChange:(NSNotification *)notification {
    
    NSLog(@"moviePlayerLoadStateDidChange: %d",[moviePlayer_ loadState]);
    if ([moviePlayer_ loadState] == MPMovieLoadStateStalled) {
        NSLog(@"Movie Playback Stalled");
    } else if([moviePlayer_ loadState] != MPMovieLoadStateUnknown) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
        
        //final set-up of video player
        [[moviePlayer_ view] setFrame:CGRectMake(0, 0, 320, 620)];
        //moviePlayer_.view.backgroundColor = [UIColor clearColor];
        [self.view addSubview:moviePlayer_.view];
        
        [self.view sendSubviewToBack:moviePlayer_.view];
        
        if([self.buttons count]>0){
            [self.view bringSubviewToFront: (UIButton*)self.buttons[0]];
            NSLog(@"in subclass: %@ ",self.buttons[0]);
        }
     
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            moviePlayer_.view.alpha = 1;
        } completion:^(BOOL finished){
            NSLog(@"!!!moviePlayer_ alpha animate complete");
            [moviePlayer_ play];
        }];
    }
}


- (void)moviePlayBackDidFinish:(NSNotification *)notification {
    //check for errors
    NSError *error = [[notification userInfo] objectForKey:@"error"];
    if (error) {
        NSLog(@"Did finish with error: %@", error);
    }else{
        NSLog(@"moviePlayBackDidFinish Did finish");
    }
    [self itsAWrap];
}


- (void)itsAWrap {
    //remove the listener
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    
    /*
    //lets go back to where we came from by hiding this view
    [self hideView];
    */
    //make sure the status bar goes away
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [moviePlayer_.view removeFromSuperview];
    moviePlayer_ = nil;
    //
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NAVIGATE_REQUEST object:self
     userInfo:(NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys: self.dataObj.oncomplete ,@"StoryboardID",
                               @"section",@"targetType",
                               nil,@"targetOptions",
                               nil]];
     //

}


#pragma mark -
#pragma mark view management

-(void)viewDidAppear:(BOOL)animated {
    
}


- (void)viewWillAppear:(BOOL)animated {
    self.view.frame = CGRectMake(0, 0, 320, 480);
    NSLog(@"ICMVideoPlayerViewController viewWillAppear");
}


- (void)viewDidDisappear:(BOOL)animated {
    moviePlayer_.contentURL = nil;
    videoURI_ = nil;
    [moviePlayer_.view removeFromSuperview];
    moviePlayer_ = nil;
    returnToViewController_ = nil;
    NSLog(@"ICMVideoPlayerViewController viewDidDisappear");
}

/*
- (void)dealloc {
    [moviePlayer_.view removeFromSuperview];
    moviePlayer_ = nil;
    returnToViewController_ = nil;
}
*/
//
- (void)viewDidUnload {
    [super viewDidUnload];
}
//
- (BOOL)shouldAutorotate;
{
    return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return (UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight | UIInterfaceOrientationPortrait);
}
@end

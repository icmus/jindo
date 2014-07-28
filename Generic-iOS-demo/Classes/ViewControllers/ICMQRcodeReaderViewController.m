//
//  ICMQRcodeReaderViewController.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/13/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMQRcodeReaderViewController.h"
#import "ICMConstants.h"

@interface ICMQRcodeReaderViewController ()

@end

@implementation ICMQRcodeReaderViewController

@synthesize readerView, dataOutput;

- (void)viewDidLoad {
    [super viewDidLoad];
	
    // the delegate receives decode results
    readerView.readerDelegate = self;
}


- (void) readerView:(ZBarReaderView*)view didReadSymbols:(ZBarSymbolSet*)syms fromImage:(UIImage*)img {
    // do something useful with results
    
   
    [self onComplete];
    
    /*
    for(ZBarSymbol *sym in syms) {
        //check results here
        NSLog(@"Scanned Data: %@",sym.data);
        
        dataOutput.text = [dataOutput.text stringByAppendingString:[NSString stringWithFormat:@"Scanned Data: %@\n", sym.data]];
        dataOutput.selectedRange = NSMakeRange(dataOutput.text.length - 1, 0);
        
        

        break;
    }
     */
}

- (void) onComplete {
    
    //TODO
    /*
     currently hardcoded to type video, need to break this out into data
     */
    
    // run the reader when the view is visible
    [[NSNotificationCenter defaultCenter]
     postNotificationName:NAVIGATE_REQUEST object:self
     userInfo:(NSDictionary *)[NSDictionary dictionaryWithObjectsAndKeys:   self.dataObj.oncomplete ,@"StoryboardID",
                               @"video",@"targetType",
                               nil,@"targetOptions",
                               nil]];
}


- (void) viewDidAppear: (BOOL) animated {
    // run the reader when the view is visible
    [readerView start];
}


- (void) viewWillDisappear: (BOOL) animated {
    [readerView stop];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (void)dealloc {
    readerView = nil;
    dataOutput = nil;
}


@end

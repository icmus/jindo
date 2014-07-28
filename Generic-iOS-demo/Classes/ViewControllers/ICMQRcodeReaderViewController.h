//
//  ICMQRcodeReaderViewController.h
//  CadburyDairyMilkPrototype
//
//  Created by Geoff Gannon on 5/13/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMAbstractViewController.h"
#import "ZBarSDK.h"

@interface ICMQRcodeReaderViewController : ICMAbstractViewController< ZBarReaderViewDelegate > {
    ZBarReaderView *readerView;
}

@property (nonatomic, strong) IBOutlet ZBarReaderView *readerView;
@property (strong, nonatomic) IBOutlet UITextView *dataOutput;

@end

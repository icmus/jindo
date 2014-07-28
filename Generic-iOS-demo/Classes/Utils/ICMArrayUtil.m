//
//  ICMArrayUtil.m
//  CadburyDairyMilkPrototype
//
//  Created by Geoffrey Gannon on 5/18/13.
//  Copyright (c) 2013 Geoff Gannon. All rights reserved.
//

#import "ICMArrayUtil.h"

@implementation ICMArrayUtil

+ (NSArray*) shuffle:(NSMutableArray*)source {

    for (uint i = 0; i < source.count; ++i) {
        int nElements = source.count - i;
        int n = arc4random_uniform(nElements) + i;
        [source exchangeObjectAtIndex:i withObjectAtIndex:n];
    }
    NSLog(@"source after %@",source);
    return source;
}



@end

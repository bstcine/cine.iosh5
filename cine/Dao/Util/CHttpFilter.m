//
//  CHttpFilter.m
//  Cine.iOS
//
//  Created by Joe Lin on 10/17/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

#import "CHttpFilter.h"

@implementation CHttpFilter

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.requestData    = [[NSMutableDictionary alloc] init];
        _requestKey = @"";
    }
    return self;
}


@end

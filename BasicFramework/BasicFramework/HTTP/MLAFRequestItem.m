//
//  MLAFRequestItem.m
//  BasicFramework
//
//  Created by luoty on 2019/5/28.
//  Copyright © 2019 luoty. All rights reserved.
//

#import "MLAFRequestItem.h"

@implementation MLAFRequestItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        _timeInterval = 20;
        _serverUrl = @"";
        _functionPath = @"";
        _requestParams = nil;
        _headerParams = @{};
        _requestMethod = MLHTTP_POST;
        
        _encrypt = NO;
        _encryptKey = @"";
        
        _showDialog = YES;
    }
    return self;
}


@end

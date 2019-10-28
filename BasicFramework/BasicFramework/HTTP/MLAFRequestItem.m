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
        _cacheType = MLIgnoringLocalCacheData;
        _requestParams = nil;
        _headerParams = @{};
        _requestMethod = MLHTTP_POST;
        
        _formDataParams = @{};
        _dataEncodingType = ML_Encoding_URL;
        _showDialog = YES;
        
        _filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    }
    return self;
}

@end

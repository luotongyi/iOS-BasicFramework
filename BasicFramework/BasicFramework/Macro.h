//
//  Macro.h
//  BasicFramework
//
//  Created by luoty on 2019/5/30.
//  Copyright © 2019 luoty. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define ML_STATUS_HEIGHT    [[UIApplication sharedApplication] statusBarFrame].size.height
#define ML_NAVBAR_HEIGHT    (ML_STATUS_HEIGHT+44)

#define ML_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define ML_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height

#define ML_ITEM_WIDTH       40
#define ML_ITEM_MARGIN      10

#define ML_WEAK_SELF(weakSelf)           __weak __typeof(&*self)weakSelf = self;
#define ML_STRING_FORMAT(string)         [NSString stringWithFormat:@"%@",(string==nil||[string isKindOfClass:[NSNull class]])?@"":string]



#endif /* Macro_h */

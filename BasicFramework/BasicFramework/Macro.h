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

// weak obj
#define ML_WEAK_OBJ(type)  __weak typeof(type) weak##type = type;
// strong obj
#define ML_STRONG_OBJ(type)  __strong typeof(type) strong##type = weak##type;

#define ML_STRING_FORMAT(string)         [NSString stringWithFormat:@"%@",(string==nil||[string isKindOfClass:[NSNull class]])?@"":string]



#endif /* Macro_h */

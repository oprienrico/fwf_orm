//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"

@implementation FWF

+ (void) resetStorage{
    [FMDbWrapper resetDatabase];
}

@end

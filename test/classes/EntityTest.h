//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORMLib.h"

@interface EntityTest : FWFEntity{
    NSString *name;
    NSNumber *number;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *number;

@end

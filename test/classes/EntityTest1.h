//
//  EntityTest1.h
//  FWF_ORM
//
//  Created by black-gray on 02/05/13.
//  Copyright (c) 2013 hjgauss. All rights reserved.
//

#import "FWF_ORM.h"

@interface EntityTest1 : FWFEntity{
    NSString *name;
    NSNumber *number;

    FWFForeignKey_XToOne *foreignKey1;
    FWFForeignKey_XToOne *foreignKey2;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *number;

@property (nonatomic, strong) FWFForeignKey_XToOne *foreignKey1;
@property (nonatomic, strong) FWFForeignKey_XToOne *foreignKey2;
@end

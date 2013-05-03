//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"

@interface EntityTest5 : FWFEntity{
    NSString *name;
    NSDate *date;
    NSNumber *number;
    OBJInteger *integer;
    OBJBool *objbool;
    
    NSArray *list;//generic data
    
    FWFForeignKey_XToOne *foreignKey1;
    
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, strong) OBJInteger *integer;
@property (nonatomic, strong) OBJBool *objbool;
@property (nonatomic, strong) NSArray *list;

@property (nonatomic, strong) FWFForeignKey_XToOne *foreignKey1;

@end

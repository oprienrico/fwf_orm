//
//  EntityTest3.m
//  FWF
//
//  Created by black-gray on 28/02/13.
//  Copyright (c) 2013 HJGauss. All rights reserved.
//

#import "EntityTest1.h"
#import "EntityTest2.h"

@implementation EntityTest1
/*-(bool) isNullEntityNotAllowed{
 return false;
 }*/

-(void) initForeignKeys{
    self.foreignKey1 = [[FWFForeignKey_XToOne alloc] initWithClass:[EntityTest2 class]];
}

@end
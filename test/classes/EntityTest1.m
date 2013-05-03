//
//  EntityTest1.m
//  FWF_ORM
//
//  Created by black-gray on 02/05/13.
//  Copyright (c) 2013 hjgauss. All rights reserved.
//

#import "EntityTest1.h"
#import "EntityTest2.h"

@implementation EntityTest1

/*-(bool) isNullEntityNotAllowed{
 return false;
 }*/

-(void) initForeignKeys{
    self.foreignKey1 = [[FWFRelationship_XToOne alloc] initWithClass:[EntityTest2 class]];
    self.foreignKey2 = [[FWFRelationship_XToOne alloc] initWithClass:[EntityTest2 class]];
    //[self.foreignKey1 setActionOnDelete:FWF_FK_ACTION_CASCADE];
}
@end

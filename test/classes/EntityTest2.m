//
//  EntityTest3.m
//  FWF
//
//  Created by black-gray on 28/02/13.
//  Copyright (c) 2013 HJGauss. All rights reserved.
//

#import "EntityTest2.h"
#import "EntityTest1.h"

@implementation EntityTest2
-(void) initForeignKeys{
    self.onetomanyfk = [[FWFForeignKey_OneToMany alloc] initWithClass:[EntityTest1 class]];
}
@end
//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "EntityTest3.h"
#import "EntityTest4.h"

@implementation EntityTest3
-(void) initForeignKeys{
    self.manytomanyfk = [[FWFRelationship_ManyToMany alloc] initWithClass:[EntityTest4 class]];
}
@end

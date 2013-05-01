//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "EntityTest4.h"
#import "EntityTest3.h"

@implementation EntityTest4
-(void) initForeignKeys{
    self.manytomanyfk = [[FWFForeignKey_ManyToMany alloc] initWithClass:[EntityTest3 class]];
}
@end

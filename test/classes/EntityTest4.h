//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"

@interface EntityTest4 : FWFEntity{
    NSString *name;
    
    FWFForeignKey_ManyToMany *onetomanyfk;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWFForeignKey_ManyToMany *manytomanyfk;

@end

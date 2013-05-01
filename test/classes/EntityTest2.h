//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORM.h"

@interface EntityTest2 : FWFEntity{
    NSString *name;
    
    FWFForeignKey_OneToMany *onetomanyfk;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWFForeignKey_OneToMany *onetomanyfk;
    
@end
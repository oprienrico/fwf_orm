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
    
    FWFRelationship_OneToMany *onetomanyfk;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWFRelationship_OneToMany *onetomanyfk;
    
@end
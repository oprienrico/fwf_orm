//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_ORMLib.h"

@interface EntityTest3 : FWFEntity{
    NSString *name;
    
    FWFRelationship_ManyToMany *onetomanyfk;
}

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) FWFRelationship_ManyToMany *manytomanyfk;

@end

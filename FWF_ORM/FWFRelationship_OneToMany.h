//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFRelationship.h"
@class FWFList;

@interface FWFRelationship_OneToMany : FWFRelationship

- (id) initWithClass:(Class)cl andDelegate:(id) del;

- (FWFList *) objects;
- (FWFList *) objectsReferencedWithAttribute:(NSString *) fkName;
- (FWFList *) objectsReferencedWithAttributes:(NSArray *) fkNameList;

@end

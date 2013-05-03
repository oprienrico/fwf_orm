//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFForeignKey.h"
#import "FWF_Costants.h"
@class FWFEntity;


@interface FWFForeignKey_XToOne : FWFForeignKey{
    NSUInteger referencedEntityPk;
}
@property (setter=setObjectPk:, getter=objectPk, nonatomic, assign) NSUInteger referencedEntityPk;


- (id) object;
- (bool) setObject:(FWFEntity *) obj;

- (NSUInteger) objectPk;
- (void) setObjectPk:(NSUInteger) pk;
- (void) setObjectWithPkNumber:(NSNumber *) pk;
- (void) setObjectWithPkOBJInteger:(OBJUInteger *) pk;

- (void) setNoObject;

//it is called by the initPersistence method to define the Action for this Foreign Key.
//call <setActionOnDelete> inside the method <initForeignKeys> (if called somewhere else, the value set will be ignored)
- (NSString *) actionOnDelete;
- (void) setActionOnDelete:(FWF_FK_ACTION) action;
@end

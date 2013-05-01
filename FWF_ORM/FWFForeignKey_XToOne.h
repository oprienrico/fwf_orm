//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFForeignKey.h"
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

- (void) noObject;
@end

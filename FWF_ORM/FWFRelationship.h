//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#pragma GCC diagnostic ignored "-Wobjc-autosynthesis-property-ivar-name-match"

#import <Foundation/Foundation.h>
#import "FMDbWrapper.h"

@interface FWFRelationship : NSObject{
    Class referencedEntityClass;
}

@property (nonatomic, strong, readonly) Class referencedEntityClass;

-(id)initWithClass:(Class)cl;
- (NSString *) referencedEntityName;

@end

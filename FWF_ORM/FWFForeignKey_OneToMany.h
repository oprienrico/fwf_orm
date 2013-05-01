//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFForeignKey.h"
@class FWFList;

@interface FWFForeignKey_OneToMany : FWFForeignKey

- (id) initWithClass:(Class)cl andDelegate:(id) del;

- (FWFList *) objects;
@end

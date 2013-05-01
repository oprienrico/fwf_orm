//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

//costants and defines
#import "FWF_Costants.h"

#import "DateUtils.h"
#import "ClassUtility.h"
#import "newOBJDataTypes.h"
#import "commonClassExtensions.h"
#import "FMDbWrapper.h"

#import "FWFList.h"
#import "FWFEntity.h"
#import "FWFForeignKey.h"
#import "FWFForeignKey_OneToMany.h"
#import "FWFForeignKey_XToOne.h"
#import "FWFForeignKey_ManyToMany.h"


@interface FWF : NSObject

+ (void) resetStorage;

@end

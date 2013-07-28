//
//  FWF
//  config file
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#define FWF_LAZY_ERRORS FALSE //default is FALSE (throw an exception when incurring in a persistence problem)

#define FWF_DEBUG FALSE //default is FALSE (logs the query executed by the FWF ORM)

#define FWF_STORAGE_AUTO_VACUUM FALSE//default is FALSE. If TRUE it keep the size of the db the smallest possible, at the cost of increased db fragmentation


/*add plugins here*/
#import "FWFImpExpPorter.h"


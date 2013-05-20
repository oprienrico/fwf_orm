//
//  FWF Utilities
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWF_Utils : NSObject

+ (NSDictionary *) filterAttributes:(NSDictionary *) dictio;
+ (NSMutableDictionary *) filterAttributesMutable:(NSMutableDictionary *) dictio;
+ (NSDictionary *) filterFK:(NSDictionary *) dictio;//unused
+ (NSMutableDictionary *) filterFKMutable:(NSMutableDictionary *) dictio;//unused
+ (id) setItemFromFMDBDictio:(NSDictionary *) dictio withClass:(Class) cl;

@end

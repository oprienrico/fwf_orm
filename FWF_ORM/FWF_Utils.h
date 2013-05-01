//
//  FWF_Utils.h
//  FWF
//
//  Created by black-gray on 04/03/13.
//  Copyright (c) 2013 HJGauss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FWF_Utils : NSObject

+ (NSDictionary *) filterAttributes:(NSDictionary *) dictio;
+ (NSMutableDictionary *) filterAttributesMutable:(NSMutableDictionary *) dictio;
+ (NSDictionary *) filterFK:(NSDictionary *) dictio;//unused
+ (NSMutableDictionary *) filterFKMutable:(NSMutableDictionary *) dictio;//unused
+ (id) setItemFromDictio:(NSDictionary *) dictio withClass:(Class) cl;
@end

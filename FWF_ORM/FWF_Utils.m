//
//  FWF_Utils.m
//  FWF
//
//  Created by black-gray on 04/03/13.
//  Copyright (c) 2013 HJGauss. All rights reserved.
//

#import "FWF_Utils.h"
#import "ClassUtility.h"
#import "newOBJDataTypes.h"
#import "commonClassExtensions.h"

#import "FWFEntity.h"
#import "FWF_Costants.h"
#import "FWFForeignKey_XToOne.h"
#import "FWFForeignKey_OneToMany.h"
#import "FWFForeignKey_ManyToMany.h"
#import "NSMutableDictionary-ext1.h"

@implementation FWF_Utils

+ (NSDictionary *) filterAttributes:(NSDictionary *) dictio{
    return [self filterAttributesMutable:[dictio mutableCopy]];
}

+ (NSMutableDictionary *) filterAttributesMutable:(NSMutableDictionary *) dictio{
    //remove keys
    [dictio removeObjectForKeyIfExists:@"pk"];//you cannot set the pk value manually

    return [self filterFKMutable:dictio];
}

+ (NSDictionary *) filterFK:(NSDictionary *) dictio{
    return [self filterFKMutable:[dictio mutableCopy]];
}

+ (NSMutableDictionary *) filterFKMutable:(NSMutableDictionary *) dictio{
    //remove every Foreign key one to many
    for (id attrName in dictio.allKeys) {
        if ([[dictio objectForKey:attrName] isKindOfClass:[FWFForeignKey_OneToMany class]]) {
            [dictio removeObjectForKey:attrName];
        }else if ([[dictio objectForKey:attrName] isKindOfClass:[FWFForeignKey_ManyToMany class]]) {
            [dictio removeObjectForKey:attrName];
        }
    }
    return dictio;
}

+ (id) setItemFromDictio:(NSDictionary *) dictio withClass:(Class) cl{
    id item = [[cl alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility getAttributesTypeFromClass:cl];
    
    //setting pk
    [item setValue:[OBJUInteger objectWithFMDBCompatibleType:[dictio objectForKey:@"pk"]] forKey:@"pkOBJ"];
    
    [[FWF_Utils filterAttributes:dictio] enumerateKeysAndObjectsUsingBlock:^(id attrName, id fmdbObj, BOOL *stop) {
        Class attrClass = [NSClassFromString([attributesType objectForKey:attrName]) class];
        
        //if it's a foreign key let's manipolate that
        if ([attrClass isSubclassOfClass:[FWFForeignKey_XToOne class]]) {
            [[item valueForKey:attrName] setObjectWithPkNumber:fmdbObj];
        }else if ([attrClass isSubclassOfClass:[FWFForeignKey_OneToMany class]]) {
            //nothing to do
        }else if ([attrClass isSubclassOfClass:[FWFForeignKey_ManyToMany class]]) {
            //nothing to do
        }else{
            //set attribute
            [item
             setValue: [attrClass objectWithFMDBCompatibleType:fmdbObj]
             forKey:attrName
             ];
        }
    }];
    
    return item;
}

@end

//
//  FWF Utilities
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWF_Utils.h"
#import "ClassUtility.h"
#import "newOBJDataTypes.h"

#import "FWFEntity.h"
#import "FWF_Costants.h"
#import "FWFRelationship_XToOne.h"
#import "FWFRelationship_OneToMany.h"
#import "FWFRelationship_ManyToMany.h"

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
        if ([[dictio objectForKey:attrName] isKindOfClass:[FWFRelationship_OneToMany class]]) {
            [dictio removeObjectForKey:attrName];
        }else if ([[dictio objectForKey:attrName] isKindOfClass:[FWFRelationship_ManyToMany class]]) {
            [dictio removeObjectForKey:attrName];
        }
    }
    return dictio;
}

+ (id) setItemFromFMDBDictio:(NSDictionary *) dictio withClass:(Class) cl{
    id item = [[cl alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:cl];
    
    //setting pk
    [item setValue:[OBJUInteger objectWithFMDBCompatibleType:[dictio objectForKey:@"pk"]] forKey:@"pkOBJ"];
    
    [[FWF_Utils filterAttributes:dictio] enumerateKeysAndObjectsUsingBlock:^(id attrName, id fmdbObj, BOOL *stop) {
        Class attrClass = [NSClassFromString([attributesType objectForKey:attrName]) class];
        
        //if it's a foreign key let's manipolate that
        if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
            [[item valueForKey:attrName] setObjectWithPkNumber:fmdbObj];
        }else if ([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]]) {
            //nothing to do
        }else if ([attrClass isSubclassOfClass:[FWFRelationship_ManyToMany class]]) {
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

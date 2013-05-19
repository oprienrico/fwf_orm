//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFRelationship_OneToMany.h"
#import "FWF_Costants.h"
#import "ClassUtility.h"
#import "commonClassExtensions.h"
#import "newOBJDataTypes.h"
#import "FWFEntity.h"
#import "FWFList.h"
#import "FWFRelationship_XToOne.h"

@interface FWFRelationship_OneToMany(){
    id delegate;
}

@property (nonatomic, weak) id delegate;

- (void) setDelegate:(id)del;

@end

@implementation FWFRelationship_OneToMany

- (id) initWithClass:(Class)cl{
    self = [super initWithClass:cl];
    return self;
}

- (id) initWithClass:(Class)cl andDelegate:(id) del{
    if(self = [super initWithClass:cl])
        delegate = del;
    return self;
}

- (void) setDelegate:(id)del{
    delegate = del;
}

- (FWFList *) objects{
    id item = [[[self referencedEntityClass] alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[self referencedEntityClass]];
    NSDictionary *attributesValues = [item getValuesDictionary];
    
    __block NSMutableArray *conditionSelQuery = [[NSMutableArray alloc] init];
    
    [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        
        //if it's a foreign key add to array (consequently used to interrogate the database)
        if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
            //recupera tutti gli attributi che si riferiscono a questa classe
            if ([[[attributesValues objectForKey:attrName] referencedEntityClass] isSubclassOfClass:[delegate class]]) {
                //create query conditions to search in the related entity (attribute = %pk_of_this_entity)
                [conditionSelQuery addObject:[NSString stringWithFormat:@"%@ = %lu", attrName, (long)[delegate pk]]];
            }
        }
    }];
    
    FWFList *listObjs = [[FWFList alloc] initWithClass:[self referencedEntityClass]];
    //there is at least one attribute, so at least one clause in the WHERE
    [listObjs setValue:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ", [self referencedEntityName], [conditionSelQuery componentsJoinedByString:@" OR "]] forKey:@"baseSQL"];
    
    return listObjs;
}

- (FWFList *) objectsReferencedWithAttribute:(NSString *) fkName{
    id item = [[[self referencedEntityClass] alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[self referencedEntityClass]];
    NSDictionary *attributesValues = [item getValuesDictionary];
    
    __block bool fk_found = false;
    
    [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        
        //if it's a foreign key add to array (consequently used to interrogate the database)
        if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
            //recupera tutti gli attributi che si riferiscono a questa classe
            if ([[[attributesValues objectForKey:attrName] referencedEntityClass] isSubclassOfClass:[delegate class]] && [attrName isEqualToString:fkName]) {
                fk_found = true;
                
                *stop = true;
            }
        }
    }];
    
    if (!fk_found) {
        @throw FWF_EXCEPTION_RELATIONSHIP_DOES_NOT_EXIST;
    }
    
    FWFList *listObjs = [[FWFList alloc] initWithClass:[self referencedEntityClass]];
    //there is at least one attribute, so at least one clause in the WHERE
    [listObjs setValue:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = %lu ", [self referencedEntityName], fkName, (long)[delegate pk]] forKey:@"baseSQL"];
    return listObjs;
}

- (FWFList *) objectsReferencedWithAttributes:(NSArray *) fkNameList{
    id item = [[[self referencedEntityClass] alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[self referencedEntityClass]];
    NSDictionary *attributesValues = [item getValuesDictionary];
    
    __block NSMutableArray *conditionSelQuery = [[NSMutableArray alloc] init];
    __block NSUInteger fks_found = 0;
    NSUInteger nfkSelected = [fkNameList count];
    
    [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        
        //if it's a foreign key add to array (consequently used to interrogate the database)
        if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
            //recupera tutti gli attributi che si riferiscono a questa classe
            if ([[[attributesValues objectForKey:attrName] referencedEntityClass] isSubclassOfClass:[delegate class]] && [fkNameList containsObject:attrName]) {
                //create query conditions to search in the related entity (attribute = %pk_of_this_entity)
                [conditionSelQuery addObject:[NSString stringWithFormat:@"%@ = %lu", attrName, (long)[delegate pk]]];
                fks_found++;
                
                if (fks_found == nfkSelected) {
                    *stop = true;
                }
            }
        }
    }];
    
    if (fks_found < nfkSelected) {
        //it means that the fkNameList contained some values that are not foreign keys in the referenced entity
        //throw an exception
        @throw FWF_EXCEPTION_RELATIONSHIP_DOES_NOT_EXIST;
    }
    
    FWFList *listObjs = [[FWFList alloc] initWithClass:[self referencedEntityClass]];
    //there is at least one attribute, so at least one clause in the WHERE
    [listObjs setValue:[NSString stringWithFormat:@"SELECT * FROM %@ WHERE %@ ", [self referencedEntityName], [conditionSelQuery componentsJoinedByString:@" OR "]] forKey:@"baseSQL"];
    
    return listObjs;
}

- (NSString *)description {
	return [NSString stringWithFormat:@"<FWFRelationship_OneToMany: linked to %@>", [self referencedEntityName]];
}
@end

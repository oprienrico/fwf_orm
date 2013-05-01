//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFForeignKey_OneToMany.h"

#import "ClassUtility.h"
#import "commonClassExtensions.h"
#import "newOBJDataTypes.h"
#import "FWF_Costants.h"
#import "FWFEntity.h"
#import "FWFList.h"
#import "FWFForeignKey_XToOne.h"

@interface FWFForeignKey_OneToMany(){
    id delegate;
}

@property (nonatomic, weak) id delegate;

- (void) setDelegate:(id)del;

@end

@implementation FWFForeignKey_OneToMany

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
    
    NSDictionary *attributesType = [ClassUtility getAttributesTypeFromClass:[self referencedEntityClass]];
    NSDictionary *attributesValues = [item getValuesDictionary];

    __block NSMutableArray *conditionSelQuery = [[NSMutableArray alloc] init];

    [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        
        //if it's a foreign key add to array (consequently used to interrogate the database)
        if ([attrClass isSubclassOfClass:[FWFForeignKey_XToOne class]]) {
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

- (NSString *)description {
	return [NSString stringWithFormat:@"<FWFForeignKey_OneToMany: linked to %@>", [self referencedEntityName]];
}
@end

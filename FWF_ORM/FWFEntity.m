//
//  FWF
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFEntity.h"

#import "ClassUtility.h"
#import "newOBJDataTypes.h"
#import "FWF_Costants.h"
#import "FWFRelationship_XToOne.h"
#import "FWFRelationship_OneToMany.h"
#import "FWFRelationship_ManyToMany.h"
#import "FWFList.h"
#import "FWF_Utils.h"

//private method
@interface FWFEntity(){
    OBJUInteger *pkOBJ;
}
@property (assign, nonatomic) OBJUInteger *pkOBJ;
@end

@implementation FWFEntity

@synthesize pkOBJ = _pkOBJ;

-(id) init{
    if (self = [super init]){
        [self checkForeignKeysInitialization];
    }
    return self;
}

-(id) initWithPersistenceCheck{
    if(self = [self init]){
        FWFORMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK; 
        [self createTableWithDb:db];
        [db close];
    }
    return self;
}

-(void) checkForeignKeysInitialization{
    //check if foreign keys are initialized correctly, if not throw custom exception
    __block bool wasInitFKNotCalled = YES;
    __block bool fkmanymanyfound = false;
    NSDictionary *attributes = [ClassUtility attributesTypeFromClass:[self class]];
    
    [attributes enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        if ([attrClass isSubclassOfClass:[FWFRelationship class]]) {
            if (wasInitFKNotCalled) {
                wasInitFKNotCalled = NO;
                if([self respondsToSelector:@selector(initForeignKeys)]){
                    [self initForeignKeys];
                }else
                    @throw(FWF_EXCEPTION_RELATIONSHIP_NOT_INITIALIZED);
            }
            id value = [self valueForKey:attrName];
            if (value == nil)
                @throw(FWF_EXCEPTION_RELATIONSHIP_NOT_INITIALIZED);
            
            if ([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]]) {
                //if is not already setted
                if ([value delegate] == nil) {
                    [value setDelegate:self];
                }else if ([value delegate] == [NSNull null]) {
                    [value setDelegate:self];
                }else if (![[value delegate] isKindOfClass:[FWFEntity class]]) {
                    @throw(FWF_EXCEPTION_RELATIONSHIP_DELEGATE_IS_NOT_ENTITY);
                }
                
                //need to verify that there is at least one linked XTOOne attibute
                id item = [[[value referencedEntityClass] alloc] init];//initialize object and foreign keys referenced class
                
                NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[value referencedEntityClass]];
                NSDictionary *attributesValues = [item getValuesDictionary];
                
                __block BOOL notFound = true;
                [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
                    Class attrClass = [NSClassFromString(attrClassName) class];
                    
                    //if it's a foreign key add to array (consequently used to interrogate the database)
                    if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
                        //check if there is one
                        if ([[[attributesValues objectForKey:attrName] referencedEntityClass] isSubclassOfClass:[self class]]) {
                            notFound = false;
                            *stop = true;
                        }
                    }
                }];
                //throw exception if there is a problem
                if (notFound) {
                    @throw FWF_EXCEPTION_REFERENCED_RELATIONSHIP_DOES_NOT_HAVE_A_CORRESPONDING_KEY;
                }
            }else if([attrClass isSubclassOfClass:[FWFRelationship_ManyToMany class]]){
                if (fkmanymanyfound) {
                    @throw FWF_EXCEPTION_RELATIONSHIP_MULTIPLE_MANY_TO_MANY_ATTRIBUTE;
                }
                fkmanymanyfound = true;
                
                //if is not already setted
                if ([value delegate] == nil) {
                    [value setDelegate:self];
                }else if ([value delegate] == [NSNull null]) {
                    [value setDelegate:self];
                }else if (![[value delegate] isKindOfClass:[FWFEntity class]]) {
                    @throw(FWF_EXCEPTION_RELATIONSHIP_DELEGATE_IS_NOT_ENTITY);
                }
            }
        }
    }];
}

-(void) initEntityPersistence{
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
    [self checkForeignKeysInitialization];
    [self createTableWithDb:db];
    [db close];
}

-(void) createTableWithDb:(FWFORMDbWrapper *)db{

    if(![db tableExists:[self entityName]]){
        __block NSString *sql = [NSString stringWithFormat: @"CREATE TABLE %@ (pk INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL ",[self entityName]];
        __block NSString *fksql_vars = [[NSString alloc] init];
        __block NSString *fksql_constr = [[NSString alloc] init];

        NSDictionary *attributes = [ClassUtility attributesTypeFromClass:[self class]];
        [attributes enumerateKeysAndObjectsUsingBlock:^(id attrName, id obj, BOOL *stop) {
            Class attrClass = [NSClassFromString(obj) class];

            if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
                fksql_vars = [fksql_vars stringByAppendingFormat:@",%@ INTEGER", attrName];
                fksql_constr = [fksql_constr stringByAppendingFormat:@", FOREIGN KEY (%@) REFERENCES %@ (pk) ON DELETE %@", attrName, [[self valueForKey:attrName] referencedEntityName], [[self valueForKey:attrName] actionOnDelete]];
            }else if ([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]]) {

            }else if ([attrClass isSubclassOfClass:[FWFRelationship_ManyToMany class]]) {
                id value = [self valueForKey:attrName];
                if(![db tableExists:[value getLookupTableName]]){
                    NSString *ref_name = [value referencedEntityName];
                    NSString * self_name = [self entityName];

                    [db executeUpdate:[NSString stringWithFormat:@"CREATE TABLE %@ (%@ INTEGER NOT NULL,%@ INTEGER NOT NULL, PRIMARY KEY(%@, %@),FOREIGN KEY (%@) REFERENCES %@(pk) ON DELETE CASCADE,FOREIGN KEY (%@) REFERENCES %@(pk) ON DELETE CASCADE)",[value getLookupTableName], self_name, ref_name, self_name, ref_name, self_name, self_name, ref_name, ref_name]];
                }
            }else{
                sql = [sql stringByAppendingFormat:@",%@ %@", attrName, [attrClass sqlType]];
            }
        }];
        sql = [sql stringByAppendingFormat:@"%@%@)", fksql_vars, fksql_constr];
        FWFLog(@"SQL:\n%@",sql);
        [db executeUpdate:sql];
    }
}

- (NSUInteger) pk{
    return [_pkOBJ unsignedIntegerValue];
}

- (NSString *) entityName{
    return NSStringFromClass([self class]);
}

+ (NSString *) entityName{
    return NSStringFromClass([self class]);
}

- (void) setValuesForAttributesWithDictionary:(NSDictionary *)keyedValues{
    [super setValuesForKeysWithDictionary:[FWF_Utils filterAttributes:keyedValues]];
}

- (NSDictionary *) getAttributesValues{
    return [FWF_Utils filterAttributes:[self getAllAttributesValues]];
}

- (NSDictionary *) getAllAttributesValues{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithDictionary:[self getValuesDictionary]];
    [attributes setValue:_pkOBJ forKey:@"pk"];
    
    return [FWF_Utils filterFKMutable:attributes];
}

- (bool) saveWithDbObj:(FWFORMDbWrapper *)database{
    //obtain value from object attributes
    NSMutableDictionary *valuesDictio = [[self getAttributesValues] mutableCopy];
    NSMutableDictionary *compatibleValuesDictio = [[NSMutableDictionary alloc] init];
    
    valuesDictio = [FWF_Utils filterAttributesMutable:valuesDictio];//filter allowed values
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[self class]];
    
    if([_pkOBJ unsignedIntegerValue]>0){
        //if pk > 0 it means its an object retrieved from db
        
        //prepare query string
        NSMutableString *sql=[[NSMutableString alloc] initWithFormat:@"UPDATE %@ SET ", [self entityName]];
        //NSLog(@"preprep dictio: %@", valuesDictio);
        [valuesDictio enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrValue, BOOL *stop) {
            Class attrClass = [NSClassFromString([attributesType objectForKey:attrName]) class];
            
            //if it's a foreign key let's manipolate that
            if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
                if (attrValue==nil){
                    @throw (FWF_EXCEPTION_RELATIONSHIP_IS_NULL);
                }
            }/*
              not necessary because is already filtered by filters from FWF_Utils
              else if([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]])
                return;//skip and do nothing*/

            //do not remove any null objects because you maybe want to set those attribute as null into the db,
            //but it's still useful into INSERT to decrease db workload
            
            //setting allowed values
            [compatibleValuesDictio setValue:[attrValue fmdbCompatibleValue] forKey:attrName];
            
            [sql appendFormat:@" %@ = :%@,", attrName, attrName];
        }];
        
        if ([self isNullEntityNotAllowed])
            if ([compatibleValuesDictio count] < 1)//do not execute query if is not allowed null entity
                return true;
        
        //delete last chara
        sql = [NSMutableString stringWithString:[sql substringToIndex:([sql length] - 1)]];
        
        [sql appendFormat:@" WHERE pk = %lu ", (long)[_pkOBJ unsignedIntegerValue]];
        
        FWFLog(@"UPDATE query : %@",sql);
        
        return [database executeUpdate:sql withParameterDictionary:compatibleValuesDictio];
    }else {
        //prepare query string
        NSMutableString *sql1=[[NSMutableString alloc] initWithFormat:@"INSERT INTO %@ (",[self entityName]];
        NSMutableString *sql2=[[NSMutableString alloc] initWithFormat:@"VALUES ("];
        
        [valuesDictio enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrValue, BOOL *stop) {
            Class attrClass = [NSClassFromString([attributesType objectForKey:attrName]) class];
            
            //if it's a foreign key let's manipolate that
            if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
                if (attrValue==nil){
                    @throw (FWF_EXCEPTION_RELATIONSHIP_IS_NULL);
                }else if (attrValue==[NSNull null]){
                    @throw (FWF_EXCEPTION_RELATIONSHIP_IS_NULL);
                }
            }/*
              not necessary because is already filtered by filters from FWF_Utils
              else if([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]])
              return;//skip and do nothing*/
            
            //if null skip and remove corresponding object
            if (attrValue==nil){
                return;
            }else if (attrValue==[NSNull null]){
                return;
            }
            
            //setting allowed values
            [compatibleValuesDictio setValue:[attrValue fmdbCompatibleValue] forKey:attrName];
            
            [sql1 appendFormat:@" %@, ", attrName];
            [sql2 appendFormat:@" :%@, ", attrName];
        }];

        if ([self isNullEntityNotAllowed])
            if ([compatibleValuesDictio count] < 1)//do not execute query if is not allowed null entity
                return true;
        
        NSString *sql=[NSString stringWithFormat:@"%@ pk) %@ NULL)",sql1,sql2];
        
        FWFLog(@"INSERT query : %@",sql);
        
        bool trans_ok = [database executeUpdate:sql withParameterDictionary: compatibleValuesDictio];
        
        //retrieve and set pk
        _pkOBJ=[OBJUInteger objuintegerWithUInteger:(NSUInteger)[database lastInsertRowId]];
        
        return trans_ok;
    }
}

- (void) save{
    //set object to modified state, set mod true when saving an entity (and not saving directly to database)
    //mod = TRUE;
    //open database
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE;
    
    [self saveWithDbObj:db];
    
    [db close];
}

- (bool) deleteWithDbObj:(FWFORMDbWrapper *)database{
    return [database executeUpdate:[[NSString alloc] initWithFormat:@"DELETE FROM %@ WHERE pk=%lu", [self entityName], (long)[_pkOBJ unsignedIntegerValue]]];
}

- (void) deleteFromStorage{
    __deleted = TRUE;
    FWFORMDbWrapper *db = FWF_STD_DB_ENGINE;
    
    [self deleteWithDbObj:db];
    
    [db close];
}

- (NSDictionary *) getValuesDictionary{
    //obtain value from object attributes
    return [self dictionaryWithValuesForKeys:[[ClassUtility attributesTypeFromClass:[self class]] allKeys]];
}

- (NSDictionary *) serializeWithDictionary{
    return [self getAllAttributesValues];
}

//sub object interface

+ (FWFList *) objects{
    return [[FWFList alloc] initWithClass:[self class]];
}

/**************/
/*  SETTINGS  */
/**************/

//allowing to save null objects is setted to false as default, override to modify this
- (bool) isNullEntityNotAllowed{
    return true;
}

@end

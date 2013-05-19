//
//  ImpExtPorter FWF Extension
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFImpExpPorter.h"

#import "FWFList.h"
#import "ClassUtility.h"
#import "FWF_Utils.h"
#import "FWF_Costants.h"

#import "FWFRelationship_XToOne.h"
#import "FWFRelationship_OneToMany.h"
#import "FWFRelationship_ManyToMany.h"

@interface FWFEntity (FWFImpExpPorter)
-(void) createTableWithDb:(FMDbWrapper *)db;
@end

@implementation FWFEntity (FWFImpExpPorter)
+ (FWFImpExpPorter *) ImpExp{
    return [[FWFImpExpPorter alloc] initWithClass:[self class]];
}
- (void)encodeWithCoder:(NSCoder *)encoder {
    [[self serializeWithDictionary] enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [encoder encodeObject:obj forKey:key];
    }];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        self = [FWF_Utils setItemFromCoder:decoder withClass:[self class]];
    }
    return self;
}

- (bool) forceSaveWithDbObj:(FMDbWrapper *)database{
    //obtain value from object attributes
    NSMutableDictionary *valuesDictio = [[self getAttributesValues] mutableCopy];
    NSMutableDictionary *compatibleValuesDictio = [[NSMutableDictionary alloc] init];
    
    valuesDictio = [FWF_Utils filterAttributesMutable:valuesDictio];//filter allowed values
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:[self class]];
    
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
    
    NSString *sql=[NSString stringWithFormat:@"%@ pk) %@ %lu)",sql1,sql2,[self pk]];//force insert(meaning that we also set the pk)
    
    FWFLog(@"INSERT query : %@",sql);
    
    return [database executeUpdate:sql withParameterDictionary: compatibleValuesDictio];
}
@end

@implementation FWFList (ListExtension_FWFImpExpPorter)
- (FWFImpExpPorter *) ImpExp{
    return [[FWFImpExpPorter alloc] initWithListObject:self];
}

@end

@implementation FWFRelationship_XToOne (RelXToOneExtension_FWFImpExpPorter)
- (id)initWithCoder:(NSCoder *)coder {
	if (self = [super init]) {
		[self setObjectPk:[coder decodeBoolForKey:@"rel"]];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeInteger:[self objectPk] forKey:@"rel"];
}
@end

@implementation FWF_Utils (UtilsExtension_FWFImpExpPorter)

+ (id) setItemFromCoder:(NSCoder *) decoder withClass:(Class) cl{
    id item = [[cl alloc] init];//initialize object and foreign keys referenced class
    
    NSDictionary *attributesType = [ClassUtility attributesTypeFromClass:cl];
    
    //setting pk
    [item setValue:[decoder decodeObjectForKey:@"pk"] forKey:@"pkOBJ"];
    
    [attributesType enumerateKeysAndObjectsUsingBlock:^(id attrName, id attrClassName, BOOL *stop) {
        Class attrClass = [NSClassFromString(attrClassName) class];
        
        //if it's a foreign key let's manipolate that
        /*if ([attrClass isSubclassOfClass:[FWFRelationship_XToOne class]]) {
         [[item valueForKey:attrName] setObjectWithPkNumber:fmdbObj];
         }else */if ([attrClass isSubclassOfClass:[FWFRelationship_OneToMany class]]) {
             //nothing to do
         }else if ([attrClass isSubclassOfClass:[FWFRelationship_ManyToMany class]]) {
             //nothing to do
         }else{
             //set attribute
             [item
              setValue: [decoder decodeObjectForKey:attrName]
              forKey:attrName
              ];
         }
    }];
    
    return item;
}
@end

@implementation FWF (Extension_FWFImpExpPorter)
+ (FWFImpExpPorter *) ImpExp{
    return [[FWFImpExpPorter alloc] initInterface];
}

@end

@interface FWFImpExpPorter (){
    FWFList *fwflist;
    NSString *className;
}
@end

@implementation FWFImpExpPorter

- (id) initWithClass:(Class) cl{
    if (self = [super init]){
        className=[cl entityName];
        fwflist=[[cl objects] all];
    }
    return self;
}

- (id) initWithListObject:(id) obj{
    if (self = [super init]){
        className=[obj entityName];
        fwflist=obj;
    }
    return self;
}

- (id) initInterface{
    if (self = [super init]){
        className=nil;
        fwflist=nil;
    }
    return self;
}

/*
 * BINARY IMPORT EXPORT
 */

- (bool) exportToBinaryFileWithPath:(NSString *) path{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    if (className == nil) {
        NSArray *listEntitiesToSave = [FWF listNamesOfStoredEntities];
        
        [archiver encodeObject:@"fwf" forKey:@"c"];//classname for typecheck
        [archiver encodeObject:listEntitiesToSave forKey:@"l"];//used to retrieve data in order
        
        [listEntitiesToSave enumerateObjectsUsingBlock:^(id entName, NSUInteger idx, BOOL *stop) {
            [archiver encodeObject:[[[NSClassFromString(entName) objects] all] listEntities] forKey:entName];
        }];
    }else{    
        [archiver encodeObject:className forKey:@"c"];//classname for typecheck
        [archiver encodeObject:[fwflist listEntities] forKey:@"l"];//list
    }
    
    [archiver finishEncoding];
    
    return [data writeToFile:path atomically:true];
}

- (bool) importFromBinaryFileWithPath:(NSString *)path{
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]){
        return false;
    }
    
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    if (className == nil) {
        if (![[unarchiver decodeObjectForKey:@"c"] isEqualToString:@"fwf"]) {
            @throw FWF_EXCEPTION_IMPEXP_IMPORT_ENTITY_MISMATCH;
        }
        NSArray *listEntitiesToSave = [unarchiver decodeObjectForKey:@"l"];
        NSArray *list = nil;
        
        FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
        [db beginTransaction];
        
        for (NSString *entName in listEntitiesToSave) {
            list = [unarchiver decodeObjectForKey:entName];
            [[NSClassFromString(entName) alloc] createTableWithDb:db];//create table if not exist
            [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [obj forceSaveWithDbObj:db];
            }];
        }
        
        [unarchiver finishDecoding];
        [db commit];
        [db close];
    }else{
        if (![className isEqualToString:[unarchiver decodeObjectForKey:@"c"]]) {
            @throw FWF_EXCEPTION_IMPEXP_IMPORT_ENTITY_MISMATCH;
        }
        NSArray *list = [unarchiver decodeObjectForKey:@"l"];
    
        [unarchiver finishDecoding];
    
        FMDbWrapper *db = FWF_STD_DB_ENGINE_NO_FK;
        [db beginTransaction];
        [[NSClassFromString(className) alloc] createTableWithDb:db];//create table if not exist
        
        [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj forceSaveWithDbObj:db];
        }];
    
        [db commit];
        [db close];
    }
    return true;
}

/*
 *  DATABASE(SQLITE) IMPORT/EXPORT
 */

- (bool) exportToSqliteFileWithPath:(NSString *) path{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *to_path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:path];
    
    //if file exist, delete it
    if ([fm fileExistsAtPath:to_path]) 
        if(![fm removeItemAtPath:to_path error:nil])
            return false;
        
    if(![fm copyItemAtPath:[FMDbWrapper standardDbPath] toPath:to_path error:nil])
        return false;
    else{
        NSLog(@"exported file to:\n%@",to_path);
        return true;
    }
}
- (bool) overwriteDataWithTemplateDbFromPath:(NSString *)path{
    return [FMDbWrapper overwriteDatabaseWithTemplateDbFromPath:path];
}
- (bool) overwriteDataWithTemplateDb{
    return [FMDbWrapper overwriteDatabaseWithTemplateDbFromPath:@"templatedb.sqlite"];
}
@end

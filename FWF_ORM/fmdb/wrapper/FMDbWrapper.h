//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

//if YES initialize foreign Keys Sqlite Modules
#define FMDB_FOREIGN_KEY TRUE

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSetAddOn.h"
#import "newOBJDataTypes.h"
#import "objc/runtime.h"


@interface FMDbWrapper : FMDatabase

+ (NSString *) standardDbPath;

- (id) initDatabase;
- (id) initDatabaseWithForeignKeys;
- (id) initDatabaseWithoutForeignKeys;

- (id) initDatabaseWithReset:(BOOL)reset;

- (id) initDatabaseWithTemplateDb;
- (id) initDatabaseWithTemplateDbFromPath:(NSString *) template_path byOverwriting:(bool)isToOverwrite;
+ (bool) overwriteDatabaseWithTemplateFromPath:(NSString *) template_path;
+ (bool) overwriteDatabaseWithTemplateDb;
+ (bool) overwriteDatabaseWithTemplateDbFromPath:(NSString *) template_path;
+ (bool) createDatabaseWithTemplateDbFromPath:(NSString *) template_path byOverwriting:(bool)isToOverwrite;

//it deletes and recreates the database (so when you will init the db the .sqlite file will already be there
+ (bool) databaseExist;
+ (bool) resetDatabase;
+ (void) deleteDatabase;
- (void) vacuum;
- (int) page_count;
- (int) freelist_count;

- (void) setupDatabaseDefaults;
- (void) activateForeignKeys;

- (NSArray *)arrayByExecutingSQL:(NSString *)sql;
- (NSArray *)arrayByExecutingSQL:(NSString *)sql overridingTypes:(NSArray *)overridedTypes;

+ (NSString *) sqlTypeFromObjCObject:(NSObject *) obj;
+ (NSString *) mysqlTypeFromObjCObject:(NSObject *) obj;
+ (NSString *) sqliteTypeFromObjCObject:(NSObject *) obj;

//utils
+ (NSString *) stringQuote;
@end

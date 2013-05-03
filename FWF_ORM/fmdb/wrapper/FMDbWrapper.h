//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

//if YES initialize foreign Keys Sqlite Modules
#define FOREIGN_KEY YES

#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSetAddOn.h"
#import "newOBJDataTypes.h"
#import "objc/runtime.h"


@interface FMDbWrapper : FMDatabase


+ (NSString *) getStandardDbPath;
+ (void) resetDatabase;

- (id)initDatabase;
- (id)initDatabaseWithForeignKeys;
- (id)initDatabaseWithoutForeignKeys;

- (id)initDatabaseWithReset:(BOOL)reset;

- (id)initDatabaseFromTemplateWithReset:(BOOL) reset;
- (id)initDatabaseFromTemplateFile:(NSString *) fileTemplate reset:(BOOL)reset;

- (NSArray *)getArrayFromExecutingSQL:(NSString *)sql;
- (NSArray *)getArrayFromExecutingSQL:(NSString *)sql overridingTypes:(NSArray *)overridedTypes;

+ (NSString *) sqlTypeFromObjCObject:(NSObject *) obj;
+ (NSString *) mysqlTypeFromObjCObject:(NSObject *) obj;
+ (NSString *) sqliteTypeFromObjCObject:(NSObject *) obj;

//utils
+ (NSString *) stringQuote;
@end

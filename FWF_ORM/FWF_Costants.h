//
//  FWF
//  costant values and defines
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//
#import "FWF_Config.h"

//#define FWF_MAIN_DB_ENGINE [[FMDbWrapper alloc] initDatabaseFromTemplateWithReset:YES]
#define FWF_STD_DB_ENGINE [[FMDbWrapper alloc] initDatabaseWithForeignKeys]
#define FWF_STD_DB_ENGINE_NO_FK [[FMDbWrapper alloc] initDatabaseWithoutForeignKeys];


/*
 *  Logging Util
 */
#ifdef FWF_DEBUG
    #if FWF_DEBUG == TRUE
        #define FWFLog(...) NSLog(__VA_ARGS__)
    #else
        #define FWFLog(...) /* */
    #endif
#else
    #define FWFLog(...) /* */
#endif


/*
 *  Exceptions
 */
#define FWF_EXCEPTION_PERSISTENCE [NSException exceptionWithName:@"FWF_EXCEPTION_PERSISTENCE" reason:@"During persistence actions the ORM incurred in an error. If the action performed was modyfing some objects, it was not applyed" userInfo:nil]
#define FWF_EXCEPTION_OBJECT_PERSISTENCE_NOT_ALLOWED [NSException exceptionWithName:@"OBJECT_PERSISTENCE_NOT_ALLOWED" reason:@"object not conform to NSCoding, or specific sqlValue method is not defined" userInfo:nil]
#define FWF_EXCEPTION_RELATIONSHIP_NOT_INITIALIZED [NSException exceptionWithName:@"RELATIONSHIP_NOT_INITIALIZED" reason:@"Foreign Keys weren't correctly initialized.\nInit them in:\n-(void) initForeignKeys" userInfo:nil]
#define FWF_EXCEPTION_REFERENCED_CLASS_NOT_COMPLIANT [NSException exceptionWithName:@"REFERENCED_CLASS_NOT_COMPLIANT" reason:@"Foreign Key refers to a class that it's not a subclass of FWFEntity" userInfo:nil]
#define FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP [NSException exceptionWithName:@"FWF_EXCEPTION_OBJECT_NOT_ISTANCE_OF_REFERENCED_CLASS_IN_RELATIONSHIP" reason:@"The object passed is not an istance of the class referenced by this Foreign Key" userInfo:nil]
#define FWF_EXCEPTION_REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED [NSException exceptionWithName:@"REFERENCED_OBJECT_NOT_EXIST_OR_IS_NOT_SAVED" reason:@"You are trying to set a reference to an object that it doesn't exist" userInfo:nil]
#define FWF_EXCEPTION_RELATIONSHIP_IS_NULL [NSException exceptionWithName:@"RELATIONSHIP_IS_NULL" reason:@"A Relationship was setted as null object" userInfo:nil]
#define FWF_EXCEPTION_RELATIONSHIP_MULTIPLE_MANY_TO_MANY_ATTRIBUTE [NSException exceptionWithName:@"FWF_EXCEPTION_RELATIONSHIP_MULTIPLE_MANY_TO_MANY_ATTRIBUTE" reason:@"The entity is declared with multiple many-to-many relationship. Only one allowed." userInfo:nil]
#define FWF_EXCEPTION_RELATIONSHIP_DELEGATE_IS_NOT_ENTITY [NSException exceptionWithName:@"RELATIONSHIP_DELEGATE_IS_NOT_ENTITY" reason:@"A Relationship was setted with a delegate that is not an Entity" userInfo:nil]
#define FWF_EXCEPTION_REFERENCED_RELATIONSHIP_DOES_NOT_HAVE_A_CORRESPONDING_KEY [NSException exceptionWithName:@"REFERENCED_RELATIONSHIP_DOES_NOT_HAVE_A_CORRESPONDING_KEY" reason:@"The OneToMany Relationship attribute was setted without setting at least one attribute of type X To One referenced to this entity" userInfo:nil]
#define FWF_EXCEPTION_RELATIONSHIP_DOES_NOT_EXIST [NSException exceptionWithName:@"FWF_EXCEPTION_RELATIONSHIP_DOES_NOT_EXIST" reason:@"The realtionship 'attribute' selected does not exist" userInfo:nil]
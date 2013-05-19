//
//  ImpExtPorter FWF Extension
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFEntity.h"
#import "FWFList.h"
#import "FWFRelationship_XToOne.h"
#import "FWF_Utils.h"

@class FWFImpExpPorter;

/*
 *  BASE MODULES EXTENSIONS
 */

@interface FWFEntity (EntityExtension_FWFImpExpPorter) <NSCoding>
+ (FWFImpExpPorter *) ImpExp;
@end

@interface FWFList (ListExtension_FWFImpExpPorter)
- (FWFImpExpPorter *) ImpExp;
@end

@interface FWFRelationship_XToOne (RelXToOneExtension_FWFImpExpPorter) <NSCoding>

@end;

@interface FWF_Utils (UtilsExtension_FWFImpExpPorter)
+ (id) setItemFromCoder:(NSCoder *) decoder withClass:(Class) cl;
@end


/*
 *  Import Export Extension
 */

/* Exceptions */
#define FWF_EXCEPTION_IMPEXP_IMPORT_ENTITY_MISMATCH [NSException exceptionWithName:@"FWF_EXCEPTION_IMPEXP_IMPORT_ENTITY_MISMATCH" reason:@"The resource contains data from a different kind of entity" userInfo:nil]

@interface FWFImpExpPorter : NSObject

- (id) initWithClass:(Class) cl;
- (id) initWithListObject:(id) obj;

//exports the selected entities to a binary file. Returns false if it encounters problems while saving.
- (bool) exportToBinaryFileWithPath:(NSString *) path;
//import into the database the entities contained in the binary file. They MUST be of the same class. Returns false if the file does not exist.
- (bool) importFromBinaryFileWithPath:(NSString *) path;

@end

//
//  FWF
//  common class Extensions for FWF
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject(FWF)
/*
 default is saved and retrieved as blob with coded as nsdata

 This method is used to indicate whether this data object can be stored as a blob in a column of a SQLite3 table. This default implementation returns YES if this object conforms to NSCoding.
 */
//+ (BOOL)canBeStoredAsBlob;
//- (BOOL)canBeStoredAsBlob;

+ (NSString *) sqlType;
- (NSString *) sqlType;

+ (id)objectWithFMDBCompatibleType:(id) value;
- (id) fmdbCompatibleValue;

@end

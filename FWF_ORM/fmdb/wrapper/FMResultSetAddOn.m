//
//  FMDB extensions
//
//  Created by Enrico Opri.
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FMResultSetAddOn.h"

@implementation FMResultSet (FMResultSetAddOn)

- (id)objectForColumnIndex:(int)columnIdx withOverridedTypes:(NSString *) overridedType {
    
    id returnValue = nil;
    
    if([overridedType length]<1){
        //if override type not setted use the usual function
        returnValue = [self objectForColumnIndex:columnIdx];
        
    }else {
        if ([overridedType isEqualToString:@"TEXT"]) {
            returnValue = [self stringForColumnIndex:columnIdx];
        }else if([overridedType isEqualToString:@"NUMBER"]){
            returnValue = [NSNumber numberWithDouble:[self doubleForColumnIndex:columnIdx]];
        }else if([overridedType isEqualToString:@"INTEGER"]){
            returnValue = [NSNumber numberWithLongLong:[self longLongIntForColumnIndex:columnIdx]];
        }else if([overridedType isEqualToString:@"BLOB"]){
            returnValue = [self dataForColumnIndex:columnIdx];
        }else if([overridedType isEqualToString:@"NSDATE"]){
            returnValue = [NSDate dateWithTimeIntervalSince1970:[self doubleForColumnIndex:columnIdx]];
            //NSLog(@"int Date : %f\nconverted NSDate : %@",[self doubleForColumnIndex:columnIdx],returnValue);
        }else {
            //default to a string for everything else
            returnValue = [self stringForColumnIndex:columnIdx];
        }
    }
    
    if (returnValue == nil) {
        returnValue = [NSNull null];
    }
    
    return returnValue;
}

- (NSDictionary*)resultDictionaryWithOverridedTypes:(NSArray *) overridedTypes {
    
    //NSUInteger num_cols = (NSUInteger)sqlite3_data_count([_statement statement]);
    NSUInteger num_cols = (NSUInteger)sqlite3_data_count((__bridge sqlite3_stmt *)([self statement]));
    
    if (num_cols > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_cols];
        
        int columnCount = [self columnCount];
        
        int columnIdx = 0;
        for (columnIdx = 0; columnIdx < columnCount; columnIdx++) {
            
            NSString *columnName = [self columnNameForIndex:columnIdx];
            id objectValue = [self objectForColumnIndex:columnIdx withOverridedTypes:[overridedTypes objectAtIndex:columnIdx]];
            [dict setObject:objectValue forKey:columnName];
        }
        
        return dict;
    }
    else {
        NSLog(@"Warning: There seem to be no columns in this set.");
    }
    
    return nil;
}

- (NSArray *)listAllResultsAsArrayOfDictio{
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    while ([self next]) {
        [resultArray addObject:[self resultDictionary]];
    }
    
    return [NSArray arrayWithArray:resultArray];
}

- (NSArray *)listAllResultsAsArrayOfDictioWithOverridedTypes:(NSArray *) overridedTypes {
    NSMutableArray *resultArray = [[NSMutableArray alloc] init];
    
    
    while ([self next]) {
        [resultArray addObject:[self resultDictionaryWithOverridedTypes:overridedTypes]];
    }
    
    return [NSArray arrayWithArray:resultArray];
}


@end

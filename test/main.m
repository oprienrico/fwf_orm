//
//  FWF
//  a test application
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FWFExamples.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        /*
         *  here are listed some callers to the examples
         */
        
        [FWF resetStorage];
        
        [FWFExamples test1];
        //[FWFExamples test2];
        //[FWFExamples testChainedSQLFiltering];
        //[FWFExamples testChainedNSPredicateFiltering];
        //[FWFExamples testRelations1];
        //[FWFExamples testRelations2];
        
        NSLog(@"This is the end, my friend!");
    }
    return 0;
}


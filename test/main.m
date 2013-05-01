//
//  main.m
//  FWF_ORM
//
//  Created by black-gray on 01/05/13.
//  Copyright (c) 2013 hjgauss. All rights reserved.
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
        
        //[FWFExamples test1];
        //[FWFExamples test2];
        //[FWFExamples testChainedSQLFiltering];
        [FWFExamples testChainedNSPredicateFiltering];
        //[FWFExamples testRelations1];
        
        NSLog(@"This is the end, my friend!");
    }
    return 0;
}


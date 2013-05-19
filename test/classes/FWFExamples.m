//
//  FWF
//  test Class
//
//  Created by Enrico Opri
//  Copyright (c) 2013 Enrico Opri. All rights reserved.
//

#import "FWFExamples.h"

#import "EntityTest.h"
#import "EntityTest1.h"
#import "EntityTest2.h"
#import "EntityTest3.h"
#import "EntityTest4.h"
#import "EntityTest5.h"

@implementation FWFExamples

+ (void) test1{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    

    FWFList *listobjs = [[EntityTest objects] all];
    NSLog(@"serialize:\n%@",[listobjs serializeWithDictionary]);
    
    EntityTest *retrievedobj = [[EntityTest objects] firstObjOrNilWithSQLPredicate:@"name='Jack'"];
    NSLog(@"retrieved obj\n%@",[retrievedobj serializeWithDictionary]);
    
    //chained queries
    retrievedobj = [[[EntityTest objects] filterWithSQLPredicate:@"number=11"] firstObjOrNilWithSQLPredicate:@"name='Mario'"];
    NSLog(@"retrieved obj with chained queryes\n%@",[retrievedobj serializeWithDictionary]);
    
    //delete every object selected previously (in this case all objects)
    [listobjs deleteFromStorage];
    NSLog(@"now empty:\n%@",[listobjs serializeWithDictionary]);
    
}
+ (void) test2{
    /*
     *  INIT ENTITIES
     */
    [[EntityTest5 alloc] initEntityPersistence];
    [[EntityTest2 alloc] initEntityPersistence];
    
    EntityTest5 *testentity = [[EntityTest5 alloc] init];
    
    testentity.name = @"test4";
    [testentity save];
    
    testentity.name = @"prova2";
    testentity.integer = [OBJInteger objintegerWithInteger:34];
    testentity.list = [NSArray arrayWithObjects:@"one", @"two", [NSDictionary dictionaryWithObjectsAndKeys:@"testobj1", @"key1", @4334, @"key2", nil], nil];
    testentity.number = @9433.45;
    testentity.date = [[NSDate alloc] init];
    testentity.objbool = [OBJBool objboolWithBool:TRUE];
    
    
    EntityTest2 *e2 = [[EntityTest2 alloc] init];
    e2.name = @"ref1";
    [e2 save];
    
    
    NSLog(@"entity2 serialized %@", [[[EntityTest2 objects] all] serializeWithDictionary]);
    
    [testentity.foreignKey1 setObject:e2];
    
    [testentity save];
    NSLog(@"fk objs (entities EntityTest obj) retrieved from entity2 %@",[[[e2 onetomanyfk] objects] serializeWithDictionary]);
    
    FWFList *tes = [[EntityTest5 objects] all];
    NSLog(@"serialize all entities EntityTest\n%@", [tes serializeWithDictionary]);
    
    NSLog(@"fk obj(an entity2 obj) retrieved from entity1 %@", [[[[tes objectWithListIndex:0] foreignKey1] object] serializeWithDictionary]);
    
    
    EntityTest5 *e = [tes objectWithPk:1];
    e.name = @"pippo";
    [e save];
    NSLog(@"serialize all 2%@\n", [e serializeWithDictionary]);
    tes = [[EntityTest5 objects] all];
    NSLog(@"serialize all 3\n%@", [tes serializeWithDictionary]);
    
    [[[EntityTest2 objects] all] deleteFromStorage];
    tes = [[EntityTest5 objects] all];
    NSLog(@"serialize all 4\n %@", [tes serializeWithDictionary]);
    
}

+ (void) testChainedSQLFiltering{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    
    
    FWFList *listobjs = [EntityTest objects];
    [listobjs beginSQLChainedFiltering];
    [[listobjs filterWithSQLPredicate:@"number=11"] filterWithSQLPredicate:@"name like '%ar%'"];
    NSLog(@"serialize:\n%@",[[listobjs executeSQLChainedFiltering] serializeWithDictionary]);

}

+ (void) testChainedNSPredicateFiltering{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    
    
    FWFList *listobjs = [EntityTest objects];
    [listobjs filterWithPredicate:@"number=11"];
    [listobjs filterWithPredicate:@"name like 'Mar*'"];
    NSLog(@"serialize:\n%@",[listobjs serializeWithDictionary]);
}

+ (void) testRelations1{
    [[EntityTest3 alloc] initEntityPersistence];
    [[EntityTest4 alloc] initEntityPersistence];
    
    //declare and store objects
    EntityTest3 *john = [[EntityTest3 alloc] init];
    john.name = @"john";
    [john save];
    EntityTest3 *jack = [[EntityTest3 alloc] init];
    jack.name = @"jack";
    [jack save];
    EntityTest3 *mark = [[EntityTest3 alloc] init];
    mark.name = @"mark";
    [mark save];
    
    EntityTest4 *chair = [[EntityTest4 alloc] init];
    chair.name = @"sedia";
    [chair save];
    EntityTest4 *table = [[EntityTest4 alloc] init];
    table.name = @"table";
    [table save];
    EntityTest4 *sofa = [[EntityTest4 alloc] init];
    sofa.name = @"my sofa";
    [sofa save];
    EntityTest4 *chocolate = [[EntityTest4 alloc] init];
    chocolate.name = @"MY CHOCOLATEEE";
    [chocolate save];
    
    [john.manytomanyfk addObject:chair];
    [john.manytomanyfk addObjectsWithArray:[NSArray arrayWithObjects:table, chocolate, nil]];
    
    //NSLog(@"serialized \n%@",[[john.manytomanyfk objects] serializeWithDictionary]);
    
    /*NSTimeInterval duration = 0;
    int ntimes=1000;
    for (int i=0; i<ntimes; i++){
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        
        //[[
        [[john.manytomanyfk objects] all];
          //filterWithSQLPredicate:@"name='my sofa'"] serializeWithDictionary];
        duration+=[NSDate timeIntervalSinceReferenceDate]-start;
    }
    NSLog(@"time %lf", duration/ntimes);*/
    NSLog(@"serialized FK manytomany: %@",[[[john.manytomanyfk objects] all] serializeWithDictionary]);
}

+ (void) testRelations2{
    [[EntityTest1 alloc] initEntityPersistence];
    [[EntityTest2 alloc] initEntityPersistence];
    
    //declare and store objects
    EntityTest1 *john = [[EntityTest1 alloc] init];
    john.name = @"john";
    [john save];
    EntityTest1 *jack = [[EntityTest1 alloc] init];
    jack.name = @"jack";
    [jack save];
    EntityTest1 *mark = [[EntityTest1 alloc] init];
    mark.name = @"mark";
    [mark save];
    
    EntityTest2 *chair = [[EntityTest2 alloc] init];
    chair.name = @"sedia";
    [chair save];
    EntityTest2 *table = [[EntityTest2 alloc] init];
    table.name = @"table";
    [table save];
    EntityTest2 *sofa = [[EntityTest2 alloc] init];
    sofa.name = @"my sofa";
    [sofa save];
    EntityTest2 *chocolate = [[EntityTest2 alloc] init];
    chocolate.name = @"MY CHOCOLATEEE";
    [chocolate save];
    
    [john.foreignKey1 setObjectWithPkOBJInteger:sofa.pkOBJ];
    [john save];
    [mark.foreignKey2 setObject:sofa];
    [mark save];

    NSLog(@"serialize FK many to one \n%@",[[[sofa.onetomanyfk objects] all] serializeWithDictionary]);
    
    NSLog(@"select only referenced entities by the foreign key specified \n%@",[[[sofa.onetomanyfk objectsReferencedWithAttribute:@"foreignKey1"] all] serializeWithDictionary]);
}

+ (void) testImportExportDatabase{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
    
    NSLog(@"exporting success: %s", [[FWF ImpExp] exportToSqliteFileWithPath:@"templatedb.sqlite"] ? "true" : "false");
    
    NSLog(@"clening and reserialize (it will return an empty set)");
    [FWF resetStorage];
    [[EntityTest alloc] initEntityPersistence];
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
    
    NSLog(@"importing success: %s", [[FWF ImpExp] overwriteDataWithTemplateDbFromPath:@"templatedb.sqlite"] ? "true" : "false");
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
}

+ (void) testImportExportSingleEntityAsBinary{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    
    NSLog(@"exporting success: %s", [[EntityTest ImpExp] exportToBinaryFileWithPath:@"test"] ? "true" : "false");
    
    NSLog(@"clening and reserialize (it will return an empty set)");
    [FWF resetStorage];
    [[EntityTest alloc] initEntityPersistence];
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
    
    NSLog(@"import");
    NSLog(@"importing success: %s", [[EntityTest ImpExp] importFromBinaryFileWithPath:@"test"] ? "true" : "false");
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
}

+ (void) testImportExportAllSavedEntitiesAsBinary{
    [[EntityTest alloc] initEntityPersistence];
    
    EntityTest *testentity = [[EntityTest alloc] init];
    
    testentity.name = @"Jack";
    [testentity save];
    
    //we can use the same pointer and init with another object (unlinked with the previous one)
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Robert";
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"John";
    testentity.number = @11;
    [testentity save];
    
    testentity = [[EntityTest alloc] init];
    testentity.name = @"Mario";
    testentity.number = @11;
    [testentity save];
    
    NSLog(@"exporting success: %s", [[FWF ImpExp] exportToBinaryFileWithPath:@"test"] ? "true" : "false");
    
    NSLog(@"clening and reserialize (it will return an empty set)");
    [FWF resetStorage];
    [[EntityTest alloc] initEntityPersistence];
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
    
    NSLog(@"import");
    NSLog(@"importing success: %s", [[FWF ImpExp] importFromBinaryFileWithPath:@"test"] ? "true" : "false");
    NSLog(@"%@", [[[EntityTest objects] all] serializeWithDictionary]);
}

+(void) testBenchmark{
    NSTimeInterval duration = 0;
    int ntimes=3;
    
    [[EntityTest alloc] initEntityPersistence];
    [[EntityTest1 alloc] initEntityPersistence];
    [[EntityTest2 alloc] initEntityPersistence];
    
    EntityTest *single = nil;
    for (int i=0; i<ntimes; i++){
        NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
        //fill the db with some objects
        for (int j=0; j<1000; j++){
            single = [[EntityTest alloc] init];
            single.name = @"testname";
            single.number = [NSNumber numberWithInt:j];
            [single save];
        }
        
        //delete all
        [[[EntityTest objects] all] deleteFromStorage];
        //filterWithSQLPredicate:@"name='my sofa'"] serializeWithDictionary];
        duration+=[NSDate timeIntervalSinceReferenceDate]-start;
    }
    NSLog(@"time %lf", duration/ntimes);
    FMDbWrapper *db = [[FMDbWrapper alloc] initDatabaseWithoutForeignKeys];
    NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
    [db close];
    
    NSTimeInterval start = [NSDate timeIntervalSinceReferenceDate];
    [FWF shrinkDownStorage];
    duration+=[NSDate timeIntervalSinceReferenceDate]-start;
    NSLog(@"cleaning time %lf", duration);
    
    EntityTest1 *single2 = nil;
    for (int j=0; j<1000; j++){
        single2 = [[EntityTest1 alloc] init];
        single2.name = @"testname";
        single2.number = [NSNumber numberWithInt:j];
        [single2 save];
    }
    
    db = [[FMDbWrapper alloc] initDatabaseWithoutForeignKeys];
    NSLog(@"freelist_count: %d\npage_count: %d", [db freelist_count], [db page_count]);
    NSLog(@"autovacuum: %d", [db intForQuery:@"PRAGMA auto_vacuum"]);
    [db close];
}
@end

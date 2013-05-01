FireWood Fridge ORM
=======

an ORM for Objective-C (both __iOS__ and __Mac OSX__) on top of SQLite

Intro
---------------------
Modeled after Active Records pattern. It supports relations (many-to-one, one-to-one, one-to-many, many-to-many).

It can be deployed both on __iOS__ and __Mac OSX__

It's based upon FMDB available at https://github.com/ccgus/fmdb/, an Objective-C wrapper around SQLite: http://sqlite.org/
	

How to use
---------------------
###Quickstart
Import into the XCode Project the `FWF_ORM` folder, __enable ARC__ and add libsqlite3.dylib (in YourProject->BuildPhases->Link Binary With Libraries)

####An Example

Define a class that inherits from `FWFEntity`, that will be our entity.
In the example we will name it `EntityTest` (wow a name that's unexpected…) with an `NSString` attribute `name`.

___NB:Attributes must be Objects! (see [`newOBJDataTypes` section](#new-obj-datatypes))___

Remember that you will need to init the persistence f your entities at startup (or before every call)
you could not do so and use everytime

	[[EntityTest alloc] initWithPersistenceCheck];
	
but it's faster to init persistence at startup
	
	[[EntityTest alloc] initEntityPersistence];
	
and somewhere else you can use the entity withou any worries

	EntityTest *jack = [[EntityTest alloc] init];
	jack.name = @"Jack White"
to save call 

	[jack save];
	
simple huh?

To retrieve the object saved:

	EntityTest *retrievedobj = [[EntityTest objects] getFirstOrNilWithSQLPredicate:@"name='Jack White'"];

Or a collection of objects:

the entire collection

	FWFList *listobjs = [[EntityTest objects] all];
	
a part of it (using filters)

	FWFList *listobjs = [[EntityTest objects] filterWithSQLPredicate:@"name like '%Whi%'"];
	
###FILTERS

####SQL based filters
	
You can use filter based on SQL (everything is appended after the keyword `WHERE`)

	FWFList *listobjs = [[EntityTest objects] filterWithSQLPredicate:@"name = 'Jack White'"];

and chain them together

	FWFList *listobjs = [[[EntityTest objects] filterWithSQLPredicate:@"name like '%Ja%'"] filterWithSQLPredicate:@"name like '%White%'"];
	
or better (because each call to the filter method executes a query and retrieve the objects, so it consumes resources)

	FWFList *listobjs = [EntityTest objects];
	[listobjs beginSQLChainedFiltering];
	#add filters
	[[listobjs filterWithSQLPredicate:@"name like '%Ja%'"] filterWithSQLPredicate:@"name like '%White%'"];
	#and now execute each filter called
	[listobjs executeSQLChainedFiltering];

####Tip:
This code

	FWFList *listobjs = [[[EntityTest objects] filterWithSQLPredicate:@"name like '%Ja%'"] filterWithSQLPredicate:@"name like '%White%'"];
	
or this one

	FWFList *listobjs = [EntityTest objects];
	[listobjs filterWithSQLPredicate:@"name like '%Ja%'"]
	[listobjs filterWithSQLPredicate:@"name like '%White%'"];
Does the same thing

####NSPredicate based filters
You can use `NSPredicate` based filters ([sintax help](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/Predicates/predicates.html#//apple_ref/doc/uid/TP40001789))

	FWFList *listobjs = [EntityTest objects];
    [listobjs filterWithPredicate:@"number=11"];
    [listobjs filterWithPredicate:@"name like 'Mar*'"];
You can chain them togheter but they are executed every time they are called (each filter is executed when called).

####Tip:
If you use the filters based on NSPredicate you can't chain after them a SQL based filter (it will overwrite the filtering made by every NSPredicate based filter).

###SERIALIZE

There are also serialization methods available that returns `NSDictionary` or `NSArray` of `NSDictionary`

	#for single entities:
	[retrievedobj serializeWithDictionary];
	
	#for collections:
	[listobjs serializeWithDictionary];

####Others Examples
You can try the examples included in the test folder. That folder does not contain dependancies for the FWF ORM.


Configurations
---------------------
###General
The FWF general configurations are stored into `FWF_Config.h`

*	FWF_LAZY_ERRORS FALSE: default is FALSE, and it throw s an exception when incurring in a persistence problem. If TRUE it's more "lazy" (less strict) about that.
*	FWF_DEBUG: default is FALSE, if true the query executed by the FWF ORM are logged

###Specific
FWFEntity could allow the storage of empty entities (every attribute is null except for the `pk`). 
DEFAULT is FALSE
If you want to allow empty entities, override the method `isNullEntityNotAllowed`, returning false

	- (bool) isNullEntityNotAllowed{
    	return false;
	SEp}
	

Tips
---------------------
The filters based on SQL are clauses that will be appended in the query after the keyword `WHERE`.

You can chain SQL filters, but remember each filter is executed every times it is invoked.
To avoid that, before executing the chained filters, call `beginSQLChainedFiltering`, and after the last filter (to retrieve the desidered data) call `executeSQLChainedFiltering`.
If you use the filters based on NSPredicate you can't chain after them a SQL based filter (it will overwrite the filtering made by every NSPredicate based filter).

It's better to use SQL based filters because they are faster (expecially with lot of data)

-------------------
New OBJ DataTypes
---------------------
They are available the "object equivalent" of some primitive types:

- OBJBool
- OBJInteger
- OBJUInteger

Use them safely as attributes of entities.

[![githalytics.com alpha](https://cruel-carlota.pagodabox.com/e50a04cf21007790f1c575db22758d6e "githalytics.com")](http://githalytics.com/hjgauss/fwf_orm)


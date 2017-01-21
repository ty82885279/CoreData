//
//  Person+CoreDataProperties.m
//  coredata
//
//  Created by Mr Lee on 2017/1/21.
//  Copyright © 2017年 lilei. All rights reserved.
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic uid;
@dynamic name;
@dynamic url;

@end

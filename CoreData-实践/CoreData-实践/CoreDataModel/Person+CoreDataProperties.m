//
//  Person+CoreDataProperties.m
//  CoreData-实践
//
//  Created by yurong on 2017/11/23.
//  Copyright © 2017年 yurong. All rights reserved.
//
//

#import "Person+CoreDataProperties.h"

@implementation Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Person"];
}

@dynamic name;

@end

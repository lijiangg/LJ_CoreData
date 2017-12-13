//
//  Person+CoreDataProperties.h
//  CoreData-实践
//
//  Created by yurong on 2017/11/23.
//  Copyright © 2017年 yurong. All rights reserved.
//
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *address;
@end

NS_ASSUME_NONNULL_END

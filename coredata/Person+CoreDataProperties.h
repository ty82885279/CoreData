//
//  Person+CoreDataProperties.h
//  coredata
//
//  Created by Mr Lee on 2017/1/21.
//  Copyright © 2017年 lilei. All rights reserved.
//

#import "Person+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

+ (NSFetchRequest<Person *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *uid;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *url;

@end

NS_ASSUME_NONNULL_END

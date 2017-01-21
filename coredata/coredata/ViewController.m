//
//  ViewController.m
//  coredata
//
//  Created by Mr Lee on 2017/1/20.
//  Copyright © 2017年 lilei. All rights reserved.
//

#import "ViewController.h"
#import "Person+CoreDataClass.h"

@interface ViewController ()
{

    NSManagedObjectContext *context;//coredata上下文

}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectModel *model = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:model];
    
    NSString *docs = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSURL *url = [NSURL fileURLWithPath:[docs stringByAppendingPathComponent:@"Person.sqlite"]];//设置数据库的路径和文件名称和类型
    
    
    // 添加持久化存储库，这里使用SQLite作为存储库
    NSError *error = nil;
    NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:nil error:&error];
    if (store == nil) { // 直接抛异常
        [NSException raise:@"添加数据库错误" format:@"%@", [error localizedDescription]];
    }
    // 初始化上下文，设置persistentStoreCoordinator属性
    context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = psc;
    
    NSLog(@"%@",NSHomeDirectory());//数据库会存在沙盒目录的document文件夹下
    

}

- (IBAction)insert:(UIButton *)sender {//插入数据
    
    
    NSManagedObject *s1 = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context]; //通过上下文找到我们的Person实体
    
    //这时候就可以像使用字典一样来给实体的属性赋值
    [s1 setValue:@"小明" forKey:@"name"];
    [s1 setValue:@"001" forKey:@"uid"];
    [s1 setValue:@"www.test.com" forKey:@"url"];
    
    NSError *error = nil;
    
    BOOL success = [context save:&error];//每次改变实体后，都要保存上下文
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"插入成功");
    }

}
- (IBAction)delete:(UIButton *)sender {//删除数据，先查询满足条件的数据，再删除
    
    //删除之前首先需要用到查询
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init]; //创建请求
    
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];//找到我们的Person
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", @"001"];//创建谓词语句，条件是uid等于001
    request.predicate = predicate; //赋值给请求的谓词语句
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行我们的请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];//抛出异常
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        
        NSLog(@"name = %@  uid = %@   url = %@", [obj valueForKey:@"name"],[obj valueForKey:@"uid"],[obj valueForKey:@"url"]); //打印符合条件的数据
        
        [context deleteObject:obj];//删除数据
    }

    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"删除成功，sqlite");
    }

}

- (IBAction)change:(UIButton *)sender {
    
    //修改数据，肯定也是要先查询，再修改
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];//创建请求
    
    request.entity = [NSEntityDescription entityForName:@"Person" inManagedObjectContext:context];//找到我们的Person
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name like %@", @"*小明*"];//查询条件：name等于小明
    request.predicate = predicate;
    
    NSError *error = nil;
    NSArray *objs = [context executeFetchRequest:request error:&error];//执行请求
    if (error) {
        [NSException raise:@"查询错误" format:@"%@", [error localizedDescription]];
    }
    // 遍历数据
    for (NSManagedObject *obj in objs) {
        
    
        [obj setValue:@"小红" forKey:@"name"];//查到数据后，将它的name修改成小红
        
    }
    
    BOOL success = [context save:&error];
    
    if (!success) {
        [NSException raise:@"访问数据库错误" format:@"%@", [error localizedDescription]];
        
    }else
    {
        NSLog(@"修改成功");
    }

}

- (IBAction)selected:(UIButton *)sender {//查询数据
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

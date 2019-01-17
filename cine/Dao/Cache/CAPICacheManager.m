//
//  CAPICacheManager.m
//  iPhone
//
//  Created by Joe Lin on 10/30/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

#import "CAPICacheManager.h"
#import "CHttpFilter.h"
#import <sqlite3.h>
#import <cine/cine-Swift.h>

@implementation CAPICacheManager{
    
    sqlite3  *_cinedb;
    NSString *_cachePath;
}

static id __cacheManager__;
    
- (NSDictionary *)responseWithRequest:(CHttpFilter *)httpFilter {
    
    return [self checkResponsWithUrl:httpFilter.path userId:[BCAuthLogic getUserModel].userId httpKey:httpFilter.requestKey];
}
- (BOOL)saveResponse:(NSDictionary *)response
         withRequest:(CHttpFilter *)httpFilter {
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:response options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSUInteger length = [data length];
    
    int size = [NSNumber numberWithUnsignedInteger:length].intValue ;
    
    NSString *currentTime = [self getCurrentTime];
    
    BOOL isSaved = [self saveResponseWithUrl:httpFilter.path userId:[BCAuthLogic getUserModel].userId httpKey:httpFilter.requestKey index:0 size:size responseText:text creat_at:currentTime update_at:currentTime];
    
    return isSaved;
}
    
+ (NSString *) getCachePath{
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, true) lastObject];
    NSString *cachePath = [cacheDirectory stringByAppendingString:@"/cineCache.sqlite"];
    return cachePath;
}

/**
 * 获取当前时间
 */
- (NSString *) getCurrentTime{
    
    NSDate *date = [NSDate date];
    
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    
    format.dateFormat = @"YYYY-MM-dd HH:mm:ss";
    
    return [format stringFromDate:date];
}

/**
 * 保存 api 数据到数据库表中
 */
- (BOOL) saveResponseWithUrl:(NSString *)url
                      userId:(NSString *)userId
                     httpKey:(NSString *)httpKey
                       index:(int)pageIndex
                        size:(int)size
                responseText:(NSString *)text
                    creat_at:(NSString *)creatTime
                   update_at:(NSString *)updateTime {

    NSString *requestId = [[NSString stringWithFormat:@"%@%@%@",url,userId,httpKey] MD5String];
    
    NSDictionary *dict = [self checkResponsWithUrl:url userId:userId httpKey:httpKey];
    
    if (dict != nil) {
        
        BOOL updateResult = [self updateResponseWithUrl:url
                                                 userId:userId
                                                httpKey:httpKey
                                                  index:pageIndex
                                                   size:size
                                           responseText:text
                                              update_at:updateTime];
        
        return updateResult;
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"INSERT INTO t_networkCache (id, api_url, user_id, http_key, http_page_index, response_size, response_text, create_at, update_at ) values (?,?,?,?,?,?,?,?,?)"];
    
    int openResult = sqlite3_open([_cachePath UTF8String], &_cinedb);
    
    if (openResult != SQLITE_OK) {
        
        return false;
    }
    
    sqlite3_stmt *stmt;
    int api = sqlite3_prepare_v2(_cinedb, [sqlString UTF8String], -1, &stmt, nil);
    if (api == SQLITE_OK) {

        sqlite3_bind_text(stmt, 1, [requestId UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 2, [url UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [userId UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 4, [httpKey UTF8String], -1, NULL);
        sqlite3_bind_int (stmt, 5, pageIndex);
        sqlite3_bind_int (stmt, 6, size);
        sqlite3_bind_text(stmt, 7, [text UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 8, [creatTime UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 9, [updateTime UTF8String], -1, NULL);

        sqlite3_step(stmt);
        
    } else {
        
        return false;
    }

    sqlite3_finalize(stmt);
    
    sqlite3_close(_cinedb);
    
    return true;
}

/**
 * 删除数据
 */
- (BOOL) deleteResponseWithId:(NSString *)requestId {
    
    int openResult = sqlite3_open([_cachePath UTF8String], &_cinedb);
    
    if (openResult != SQLITE_OK) {
        
        return false;
    }
    
    NSString *sqlString = [NSString stringWithFormat:@"DELETE from t_networkCache WHERE id = '%@';", requestId];
    
    BOOL isResult = [self exeSQL:sqlString];
    
    sqlite3_close(_cinedb);
    
    return isResult;
}

/**
 * 更新 api 数据到数据库表
 */
- (BOOL) updateResponseWithUrl:(NSString *)url
                        userId:(NSString *)userId
                       httpKey:(NSString *)httpKey
                         index:(int)pageIndex
                          size:(int)size
                  responseText:(NSString *)text
                     update_at:(NSString *)updateTime {
    
    int openResult = sqlite3_open([_cachePath UTF8String], &_cinedb);
    
    if (openResult != SQLITE_OK) {
        
        return false;
    }
    
    NSString *requestId = [[NSString stringWithFormat:@"%@%@%@",url,userId,httpKey] MD5String];
    
    NSString *sqlString = [NSString stringWithFormat:@"UPDATE t_networkCache SET response_size = ?, response_text = ?, update_at = ? WHERE id = '%@';", requestId];
    
    sqlite3_stmt *stmt;
    
    int api = sqlite3_prepare_v2(_cinedb, [sqlString UTF8String], -1, &stmt, nil);
    
    if (api == SQLITE_OK) {
        
        sqlite3_bind_int (stmt, 1, size);
        sqlite3_bind_text(stmt, 2, [text UTF8String], -1, NULL);
        sqlite3_bind_text(stmt, 3, [updateTime UTF8String], -1, NULL);
        
        sqlite3_step(stmt);
        
    } else {
        
        return false;
    }
    
    sqlite3_finalize(stmt);
    
    sqlite3_close(_cinedb);
    
    return true;
}

- (NSDictionary *) checkResponsWithUrl:(NSString *)url
                      userId:(NSString *)userId
                     httpKey:(NSString *)httpKey {
    
    NSString *requestId = [[NSString stringWithFormat:@"%@%@%@",url,userId,httpKey] MD5String];
    
    NSString *sqlString = [NSString stringWithFormat:@"select * from t_networkCache where id = '%@'",requestId];
    
    NSArray *resultArray = [self queryRecords:sqlString];
    
    if (resultArray == nil) {
        return nil;
    }
    
    NSDictionary *result = [resultArray lastObject];
    
    if (result == nil) {
        return nil;
    }
    
    NSString *response = result[@"response_text"];
    
    if (response == nil || [response isEqualToString:@""]) {
        return [NSDictionary dictionary];
    }
    
    NSData *data = [response dataUsingEncoding:NSUTF8StringEncoding];

    NSError *error;
    
    NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    
    return responseObject;
}


+ (instancetype) sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __cacheManager__ = [[self alloc] init];
    });
    return __cacheManager__;
}

+ (instancetype) defaultManager {
    
    return [self sharedManager];
}
+ (void) deleteDataBase {
    
    NSString *cachePath = [self getCachePath];
    
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:cachePath];
    
    if (isExist) {
        
        BOOL deleteStatus = [[NSFileManager defaultManager] removeItemAtPath:cachePath error:nil];
        
        if (deleteStatus){
            
            NSLog(@"删除成功");
        }
    }
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _cachePath = [CAPICacheManager getCachePath];
        
        int openResult = sqlite3_open(_cachePath.UTF8String, &_cinedb);
        if(openResult == SQLITE_OK) {
            
            [self creatTable];
            
        }else {
            // 打开失败,创建失败
            NSLog(@"打开失败");
        }
        sqlite3_close(_cinedb);
    }
    return self;
}

- (void) creatTable {
    // com.bstcine.Cine-iOS
    NSBundle *bundle = [NSBundle bundleWithIdentifier:@"com.bstcine.cine"];
    NSString *cachePath = [NSString stringWithFormat:@"%@/CineBundle.bundle/cacheTable.sql",bundle.bundlePath];
    NSString *creatCacheTable = [NSString stringWithContentsOfFile:cachePath encoding:NSUTF8StringEncoding error:NULL];
    if ([self exeSQL:creatCacheTable]) {
        NSLog(@"建表成功");
    }else{
        NSLog(@"建表失败");
    }
}

#pragma mark
#pragma mark - 增,删,改方法
- (BOOL) exeSQL:(NSString *)sql {
    
    char *error;
    int exeResult = sqlite3_exec(_cinedb,sql.UTF8String,NULL,NULL,&error);
    
    if(exeResult == SQLITE_OK) {
        
        if(error){
            
            NSLog(@"%s",error);
            return NO;
        }
        NSLog(@"work success");
        return YES;
    }else {
        
        NSLog(@"work failure");
        return NO;
    }
}


#pragma mark
#pragma mark - 查询方法
- (NSArray<NSDictionary *> *)queryRecords:(NSString *)sql {
    
    
    NSMutableArray<NSDictionary *> *arrayM = [NSMutableArray array];
    
    sqlite3_open(_cachePath.UTF8String, &_cinedb);
    
    sqlite3_stmt *ppstmt;
    int stmtResult = sqlite3_prepare_v2(_cinedb, sql.UTF8String, -1, &ppstmt, NULL);
    
    // 判断准备结果,如果准备成功,将执行预编译指令
    if(stmtResult == SQLITE_OK) {
        
        // sqlite3_step(ppstmt) 返回结果为 SQLITE_DONE 时,表示执行成功,为 SQLITE_ROW 表示未执行完毕
        while(sqlite3_step(ppstmt) == SQLITE_ROW){
            
            // 获取返回行的列数
            int colCount = sqlite3_column_count(ppstmt);
            
            // 遍历列数,将所有的列保存到字典中
            // 创建可变字典,保存列信息
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            
            for (int i = 0; i < colCount; i++) {
                
                // 获取对应列的名称,不允许对名称修改
                const char *colName = sqlite3_column_name(ppstmt, i);
                
                // 根据列名称生成字符串对象,作为可变的键
                NSString *colNameStr = [[NSString alloc] initWithUTF8String:colName];
                
                // 获取对应列的值
                // 获取对应列的类型
                int colType = sqlite3_column_type(ppstmt, i);
                
                // 根据数值类型,对数据进行不同的函数取值
                switch (colType) {
                    case SQLITE_INTEGER:
                        // 获取整数
                    {int colNumber = sqlite3_column_int(ppstmt, i);
                        
                        // 添加到可变字典中
                        [dictM setObject:@(colNumber) forKey:colNameStr];
                    }
                        break;
                        
                    case SQLITE_TEXT:
                    {
                        const unsigned char * colText = sqlite3_column_text(ppstmt, i);
                        NSString *colTextStr = [[NSString alloc] initWithUTF8String:(const char *)colText];
                        [dictM setObject:colTextStr forKey:colNameStr];
                    }
                        break;
                        
                    case SQLITE_FLOAT:
                    {
                        double colReal = sqlite3_column_double(ppstmt, i);
                        [dictM setObject:@(colReal) forKey:colNameStr];
                    }
                        break;
                        
                    case SQLITE_BLOB:
                        NSLog(@"%s",colName);
                        break;
                        
                    default:
                        break;
                }
                
            }
            
            // 把字典加入到字典数组中
            [arrayM addObject:dictM];
        }
    }else{
        
        NSLog(@"queryRecords is failure");
    }
    
    sqlite3_close(_cinedb);
    
    return arrayM.copy;
}


@end

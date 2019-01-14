//
//  CPage.m
//  Cine.iOS
//
//  Created by Joe Lin on 10/17/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

#import "CPage.h"

@implementation CPageModel

- (void)setValuesForKeysWithDictionary:(NSDictionary<NSString *,id> *)keyedValues {
    
    self.curPage = [keyedValues[@"cur_page"] integerValue];
    self.maxPage = [keyedValues[@"max_page"] integerValue];
    self.totalRows = [keyedValues[@"total_rows"] integerValue];
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    NSLog(@"You Should Set [NEW PROPERTY] for: %@",key);
}

@end

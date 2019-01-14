//
//  CError.h
//  iPhone
//
//  Created by Joe Lin on 10/18/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CError : NSObject

@property (nonatomic, assign) BOOL isExcept;
@property (nonatomic, strong, nullable) NSError * error;
@property (nonatomic, copy, nullable) NSString * except_case;
@property (nonatomic, copy, nullable) NSString * except_case_desc;
@property (nonatomic, copy, nullable) NSString * code_desc;

@end

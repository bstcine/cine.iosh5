//
//  CAPICacheManager.h
//  iPhone
//
//  Created by Joe Lin on 10/30/17.
//  Copyright © 2017 善恩英语. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CHttpFilter;

/**
 api_url,
 user_id,
 http_key,
 http_page_index,
 response_size,
 response_text,
 create_at,
 update_at
 */

@interface CAPICacheManager : NSObject

+ (instancetype) sharedManager;
+ (instancetype) defaultManager;

- (NSDictionary *)responseWithRequest:(CHttpFilter *)httpFilter;

- (BOOL)saveResponse:(NSDictionary *)response withRequest:(CHttpFilter *)httpFilter;

+ (void) deleteDataBase;

@end

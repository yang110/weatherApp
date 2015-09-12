//
//  DataService.h
//  04微博
//
//  Created by Mac on 15/8/12.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "Header.h"



typedef void(^BlockType)(id result);

@interface DataService : NSObject

//
//
//+(void)requestUrl:(NSString *)urlString
//       httpMethod:(NSString *)method
//           params:(NSMutableDictionary *)params
//            block:(BlcokType)block;
//
//
//
//+(AFHTTPRequestOperation *)requestAFUrl:(NSString *)urlString
//                             httpMethod:(NSString *)method
//                                 params:(NSMutableDictionary *)params
//                                  datas:(NSMutableDictionary *)dicData
//                                  block:(BlcokType)block;
//
+(void)requestAFUrl:(NSString *)urlString httpMethod:(NSString *)method params:(NSMutableDictionary *)params data:(NSMutableDictionary *)datas block:(BlockType)block;

+ (id)loadData:(NSString *)string;
@end

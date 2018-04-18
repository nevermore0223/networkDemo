//
//  RequestManager.h
//  networkDemo
//
//  Created by onlinei2 on 2018/3/14.
//  Copyright © 2018年 onlinei2. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^callBackBlock)(BOOL isSuccess,int code,NSDictionary *resultDic);
@interface RequestManager : NSObject
+(RequestManager *)sharedManager;
-(void)requestURL:(NSString *)url parameters:(NSDictionary *)para completionHandler :(callBackBlock)completionHandler;
-(NSDictionary *)appendingUniversalParamsAndEcoding:(NSDictionary *)paraDic;
@end

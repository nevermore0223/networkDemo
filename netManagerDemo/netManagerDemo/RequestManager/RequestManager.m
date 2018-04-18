//
//  RequestManager.m
//  networkDemo
//
//  Created by onlinei2 on 2018/3/14.
//  Copyright © 2018年 onlinei2. All rights reserved.
//

#import "RequestManager.h"
#import "AFHTTPSessionManager.h"
#import <AdSupport/ASIdentifierManager.h>
#import "DataEncode.h"
#import "NSString+MD5.h"
static RequestManager *sharedManager = nil;
@implementation RequestManager
+(RequestManager *)sharedManager{
    if (sharedManager == nil) {
        sharedManager = [[RequestManager alloc ]init];
    }
    return sharedManager;
}
-(void)requestURL:(NSString *)url parameters:(NSDictionary *)para completionHandler :(callBackBlock)completionHandler{
    NSDictionary *completePara = [self appendingUniversalParamsAndEcoding:para];
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager ];
    session.responseSerializer.acceptableContentTypes = [session.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    [session POST:url parameters:completePara progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSNumber *code = responseObject[@"c"];
        if (code.intValue == 1111) {
            completionHandler(true,code.intValue,responseObject);
        }else{
            completionHandler(false,code.intValue,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completionHandler(false,(int)[error code],@{@"c":[NSNumber numberWithInteger:[error code]],@"m":[error localizedDescription]});   
    }];
    
}
-(NSDictionary *)appendingUniversalParamsAndEcoding:(NSDictionary *)paraDic{
    NSString *signKEY = @"r3RrWeVhubjTWL42qWdZzAKh5aVJ2MmC";
    NSString *tripleKEY = @"Qr9hGDPGhTdCjrJKfQnpXcK9";
    NSDate *dateNow= [NSDate date];
    NSString *timeStamp =[NSString stringWithFormat:@"%f",[dateNow timeIntervalSince1970] ] ;
    NSString *clientVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *appKey = [[[ASIdentifierManager sharedManager]advertisingIdentifier ]UUIDString];
    NSDictionary *dic = @{@"t":timeStamp,@"v":clientVersion,@"serial":appKey,@"mac":@"",@"auth":@"4649ff38bc153e44a8d2"};
    NSMutableDictionary *universalParam = [NSMutableDictionary dictionaryWithDictionary:dic];
    [universalParam addEntriesFromDictionary:paraDic];
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:universalParam options:NSJSONWritingPrettyPrinted error:&error ];
    NSString *jsonString = [[NSString alloc ]initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString : %@",jsonString);
    NSString *TripleDESCode = [DataEncode TripleDES:jsonString encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:tripleKEY ];
    TripleDESCode = [TripleDESCode stringByReplacingOccurrencesOfString:@"+" withString:@"-"];
    TripleDESCode = [TripleDESCode stringByReplacingOccurrencesOfString:@"=" withString:@"!"];
    TripleDESCode = [TripleDESCode stringByReplacingOccurrencesOfString:@"/" withString:@"_"];
    NSString *finalSign = [[[signKEY stringByAppendingString:TripleDESCode ]MD5]uppercaseString];
    NSString *finalPVS = [[[[[@"01" stringByAppendingString:@"02"] stringByAppendingString:@"02"] stringByAppendingString:@"00"]stringByAppendingString:finalSign ] stringByAppendingString:TripleDESCode];
    return @{@"__pc":finalPVS};
}
@end

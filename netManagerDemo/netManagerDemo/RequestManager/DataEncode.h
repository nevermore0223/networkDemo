//
//  DataEncode.h
//  
//
//  Created by ankey on 15/4/30.
//
//

#import <Foundation/Foundation.h>

#import <CommonCrypto/CommonCrypto.h>
#import "NSString+MD5.h"
#import "GTMBase64.h"

@interface DataEncode : NSObject

+ (NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey;

+ (NSString*)transfor3DES:(NSString*)plainText enc:(CCOperation)encryptOrDecrypt;

@end

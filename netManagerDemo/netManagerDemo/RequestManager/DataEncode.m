//
//  DataEncode.m
//  
//
//  Created by ankey on 15/4/30.
//
//

#import "DataEncode.h"

#define KEY @"abcdabcdabcdabcdabcdabcd"

@implementation DataEncode

+(NSString *)TripleDES:(NSString *)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt encryptOrDecryptKey:(NSString *)encryptOrDecryptKey
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];

        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }else{
//        plainText = [self pkcsPad:plainText]; //加上 kCCOptionPKCS7Padding 之後就是自動補位，不必自己寫補位的function 了
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[encryptOrDecryptKey UTF8String];

    CCCrypt(encryptOrDecrypt,
           kCCAlgorithm3DES,
           kCCOptionECBMode | kCCOptionPKCS7Padding,
           vkey,
           kCCKeySize3DES,
           nil,
           vplainText,
           plainTextBufferSize,
           (void *)bufferPtr,
           bufferPtrSize,
           &movedBytes);
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                                length:(NSUInteger)movedBytes]
                                        encoding:NSUTF8StringEncoding];
    }else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    free(bufferPtr);
    return result;
}

+ (NSString*)transfor3DES:(NSString*)plainText enc:(CCOperation)encryptOrDecrypt
{
    if (encryptOrDecrypt == kCCEncrypt) {
        NSString *firstResult = [self TripleDES:plainText encryptOrDecrypt:kCCEncrypt encryptOrDecryptKey:KEY];
        
        NSData *tempData = [GTMBase64 decodeString:firstResult];
        
        NSString *str = [[NSString alloc]initWithData:tempData encoding:NSASCIIStringEncoding];
        
        str = [str stringToHex];// [NSString stringToHex:str];//转为16进制
        return str;
    }else if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *tempdata = [self hexStringToData:plainText];
        
        NSString *tempstr = [GTMBase64 stringByEncodingData:tempdata];
        
        return [self TripleDES:tempstr encryptOrDecrypt:kCCDecrypt encryptOrDecryptKey:KEY];
    }

    return @"";
}


+(NSString *)pkcsPad:(NSString * )pString {
    NSInteger size = kCCBlockSize3DES - pString.length%kCCBlockSize3DES;
    const unichar cha = size;
    
    const char *ch =  [[NSString stringWithFormat:@"%c",cha] cStringUsingEncoding:NSASCIIStringEncoding];
    for (int i = 0; i < size; i++) {
        pString = [pString stringByAppendingFormat:@"%s",ch];
    }
    return  pString;
}

+(NSString *)pkcsSpacePad:(NSString * )pString {
    NSInteger size = kCCBlockSize3DES - pString.length%kCCBlockSize3DES;
    
    for (int i = 0; i < size; i++) {
        pString = [pString stringByAppendingFormat:@""];
    }
    return  pString;
}

+(NSData *)dataPkcsPad:(NSData *)data
{
    NSInteger size = kCCBlockSize3DES - data.length%kCCBlockSize3DES;
    
    const void *ch = [@"" UTF8String];
    
    NSMutableData *temp = [NSMutableData dataWithData:data];
    for (int i = 0; i < size; i++) {
         [temp appendBytes:ch length:1];
    }
    return  temp;
}



+(NSData *)hexStringToData:(NSString *)hexStr
{
//    NSString *hexStr = @"ef5ff508a429f1978b4e0a765bd6b639c4b56561220df214";
    int len = (int)[hexStr length] / 2 ;
    char *bu = (char *)malloc(len);
    bzero(bu, len );
    for (int i = 0; i < [hexStr length] - 1; i += 2) {
        unsigned int anInt;
        NSString * hexCharStr = [hexStr substringWithRange:NSMakeRange(i, 2)];
        NSScanner * sc = [[NSScanner alloc] initWithString:hexCharStr] ;
        [sc scanHexInt:&anInt];
        bu[i / 2] = (char)anInt;
    }
    NSData *data = [[NSData alloc] initWithBytes:bu length:len];
    free(bu);
    
    return data;
}

@end

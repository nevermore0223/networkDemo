//
//  NSString+MD5.m
//  NSData+MD5Digest
//
//  Created by PO-YU SU on 2014/7/30.
//
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@implementation NSString (MD5)

- (NSString *) stringToHex
{
    NSUInteger len = [self length];
    unichar *chars = malloc(len * sizeof(unichar));
    [self getCharacters:chars];
    
    NSMutableString *hexString = [[NSMutableString alloc] init];
    
    for(NSUInteger i = 0; i < len; i++ )
    {
        [hexString appendString:[NSString stringWithFormat:@"%2.x", chars[i]]];
    }
    free(chars);
    
    while ([hexString containsaString:@" "]){
        [hexString replaceCharactersInRange:[hexString rangeOfString:@" "] withString:@"0"];
    }
    
    return hexString ;
}

- (NSString *)stringFromHex:(NSString *)str
{
    NSMutableData *stringData = [[NSMutableData alloc] init];
    unsigned char whole_byte;
    char byte_chars[3] = {'\0','\0','\0'};
    int i;
    for (i=0; i < [str length] / 2; i++) {
        byte_chars[0] = [str characterAtIndex:i*2];
        byte_chars[1] = [str characterAtIndex:i*2+1];
        whole_byte = strtol(byte_chars, NULL, 16);
        [stringData appendBytes:&whole_byte length:1];
    }
    return [[NSString alloc] initWithData:stringData encoding:NSASCIIStringEncoding];
}

- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, (CC_LONG)strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSString *)CutBlankSpaceInHeadAndEnd
{
    if (self == nil ||
        [self isEqualToString:@""] ||
        self.length == 0) {
        return self;
    }
    NSMutableString *temp = [NSMutableString stringWithString:self];

//    temp = (NSMutableString *)[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //去掉头空格
    while ([[temp substringToIndex:1] isEqualToString:@" "] || [[temp substringToIndex:1] isEqualToString:@"\n"]) {
        temp = [NSMutableString stringWithString: [temp substringFromIndex:1]];
    }
    //去掉尾空格
    while ([[temp substringFromIndex:temp.length - 1] isEqualToString:@" "] || [[temp substringFromIndex:temp.length - 1] isEqualToString:@"\n"]) {
        temp = [NSMutableString stringWithString: [temp substringToIndex:temp.length - 1]];
    }
    return [temp stringByAppendingString:@""];
}

+ (NSString *)timeStringWithSeconds:(int)totalSeconds
{
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = (totalSeconds / 3600) % 24;
    int day = totalSeconds / (3600 * 24);
    
    if (day > 0) {
        return [NSString stringWithFormat:@"%d天%02d時%02d分%02d秒",day,hours, minutes,seconds];
    }
    if (hours > 0)
    {
        return [NSString stringWithFormat:@"%02d時%02d分%02d秒",hours, minutes, seconds];
    }
    if (minutes > 0)
    {
        return [NSString stringWithFormat:@"%02d分%02d秒", minutes, seconds];
    }
    return [NSString stringWithFormat:@"%02d秒", seconds];
}
-(NSString *)localizedString
{
    return NSLocalizedString(self, @"");
}

- (BOOL)containsString:(NSString *)aString
{
    return [self containsaString:aString];
}
- (BOOL)containsaString:(NSString *)aString
{
    NSRange range = [self rangeOfString:aString];
    if (range.length == aString.length) {
        return YES;
    }
    return NO;
}

- (BOOL)IsValidateEmail
{
//    NSString *email = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\.\\w+([-.]\\w+)*$";
    NSString *email = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",email];
    return [emailPre evaluateWithObject:self];
}

- (BOOL)smallerThan:(NSString *)otherString
{
    NSComparisonResult result = [self compare:otherString];
    
    return result == NSOrderedAscending;
}

- (BOOL)versionLessThan:(NSString *)_newver
{
    NSArray *a1 = [self componentsSeparatedByString:@"."];
    NSArray *a2 = [_newver componentsSeparatedByString:@"."];
    
    for (int i = 0; i < [a1 count]; i++) {
        if ([a2 count] > i) {
            if ([[a1 objectAtIndex:i] floatValue] < [[a2 objectAtIndex:i] floatValue]) {
                return YES;
            }
            else if ([[a1 objectAtIndex:i] floatValue] > [[a2 objectAtIndex:i] floatValue])
            {
                return NO;
            }
        }
        else
        {
            return NO;
        }
    }
    return [a1 count] < [a2 count];
}


@end


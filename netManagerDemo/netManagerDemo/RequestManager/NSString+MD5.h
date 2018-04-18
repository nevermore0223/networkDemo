//
//  NSString+MD5.h
//  NSData+MD5Digest
//
//  Created by PO-YU SU on 2014/7/30.
//
//

#import <Foundation/Foundation.h>

@interface NSString(MD5)

- (NSString *)stringToHex;
- (NSString *)stringFromHex:(NSString *)hexString;


- (NSString *)MD5;

- (NSString *)CutBlankSpaceInHeadAndEnd;

+ (NSString *)timeStringWithSeconds:(int)totalSeconds;

- (NSString *)localizedString;//本地化字符串

- (BOOL)containsString:(NSString *)aString;

- (BOOL)containsaString:(NSString *)aString;

- (BOOL)IsValidateEmail;

- (BOOL)smallerThan:(NSString *)otherString;
- (BOOL)versionLessThan:(NSString *)_newver;

@end

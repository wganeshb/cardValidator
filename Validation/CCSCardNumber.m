//
//  CCSCardNumber.m
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import "CCSCardNumber.h"

@implementation CCSCardNumber {
@private
    NSString *_number;
}

+ (instancetype)cardNumberWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        // Strip non-digits
        _number = [string stringByReplacingOccurrencesOfString:@"\\D"
                                                    withString:@""
                                                       options:NSRegularExpressionSearch
                                                         range:NSMakeRange(0, string.length)];
    }
    return self;
}

- (CCSCardType)cardType
{
    if (_number.length < 2) {
        return CCSCardTypeUnknown;
    }
    
    NSString *firstChars = [_number substringWithRange:NSMakeRange(0, 2)];
    NSInteger range = [firstChars integerValue];
    
    if (range >= 40 && range <= 49) {
        return CCSCardTypeVisa;
    } else if (range >= 50 && range <= 59) {
        return CCSCardTypeMasterCard;
    } else if (range == 34 || range == 37) {
        return CCSCardTypeAmex;
    } else if ([_number hasPrefix:@"6011"] || [_number hasPrefix:@"65"]) {
        return CCSCardTypeDiscover;
    } else if ([_number hasPrefix:@"622"]) {
        // If the number has a prefix in the range 622126-622925, it's Discover
        NSUInteger prefixLength = 6;
        if (_number.length >= prefixLength) {
            NSInteger sixDigitPrefix = [[_number substringWithRange:NSMakeRange(0, prefixLength)] integerValue];
            if ((sixDigitPrefix >= 622126) && (sixDigitPrefix <= 622925)) {
                return CCSCardTypeDiscover;
            }
        }
        return CCSCardTypeUnknown;
    } else if (range == 64) {
        // If the number has a prefix in the range 644-649, it's Discover
        NSUInteger prefixLength = 3;
        if (_number.length >= prefixLength) {
            NSInteger threeDigitPrefix = [[_number substringWithRange:NSMakeRange(0, prefixLength)] integerValue];
            if ((threeDigitPrefix >= 644) && (threeDigitPrefix <= 649)) {
                return CCSCardTypeDiscover;
            }
        }
        return CCSCardTypeUnknown;
    } else if (range == 35) {
        return CCSCardTypeJCB;
    } else if (range == 30 || range == 36 || range == 38 || range == 39) {
        return CCSCardTypeDinersClub;
    } else {
        return CCSCardTypeUnknown;
    }
}

- (NSString *)last4
{
    if (_number.length >= 4) {
        return [_number substringFromIndex:([_number length] - 4)];
    } else {
        return nil;
    }
}

- (NSString *)lastGroup
{
    if (self.cardType == CCSCardTypeAmex) {
        if (_number.length >= 5) {
            return [_number substringFromIndex:([_number length] - 5)];
        }
    } else {
        if (_number.length >= 4) {
            return [_number substringFromIndex:([_number length] - 4)];
        }
    }
    
    return nil;
}


- (NSString *)string
{
    return _number;
}

- (NSString *)formattedString
{
    NSRegularExpression *regex;
    
    if (self.cardType == CCSCardTypeAmex) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{1,4})(\\d{1,6})?(\\d{1,5})?" options:0 error:NULL];
    } else {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(\\d{1,4})" options:0 error:NULL];
    }
    
    NSArray *matches = [regex matchesInString:_number options:0 range:NSMakeRange(0, _number.length)];
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:matches.count];
    
    for (NSTextCheckingResult *match in matches) {
        for (int i = 1; i < [match numberOfRanges]; i++) {
            NSRange range = [match rangeAtIndex:i];
            
            if (range.length > 0) {
                NSString *matchText = [_number substringWithRange:range];
                [result addObject:matchText];
            }
        }
    }
    
    return [result componentsJoinedByString:@" "];
}

- (NSString *)formattedStringWithTrail
{
    NSString *string = [self formattedString];
    NSRegularExpression *regex;
    
    // No trailing space needed
    if ([self isValidLength]) {
        return string;
    }
    
    if (self.cardType == CCSCardTypeAmex) {
        regex = [NSRegularExpression regularExpressionWithPattern:@"^(\\d{4}|\\d{4}\\s\\d{6})$" options:0 error:NULL];
    } else {
        regex = [NSRegularExpression regularExpressionWithPattern:@"(?:^|\\s)(\\d{4})$" options:0 error:NULL];
    }
    
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:string options:0 range:NSMakeRange(0, string.length)];
    
    if (numberOfMatches == 0) {
        // Not at the end of a group of digits
        return string;
    } else {
        return [NSString stringWithFormat:@"%@ ", string];
    }
}

- (BOOL)isValid
{
    return [self isValidLength] && [self isValidLuhn];
}

- (BOOL)isValidLength
{
    return _number.length == [self lengthForCardType];
}

- (BOOL)isValidLuhn
{
    BOOL odd = true;
    int sum = 0;
    NSMutableArray *digits = [NSMutableArray arrayWithCapacity:_number.length];
    
    for (int i = 0; i < _number.length; i++) {
        [digits addObject:[_number substringWithRange:NSMakeRange(i, 1)]];
    }
    
    for (NSString *digitStr in [digits reverseObjectEnumerator]) {
        int digit = [digitStr intValue];
        if ((odd = !odd)) digit *= 2;
        if (digit > 9) digit -= 9;
        sum += digit;
    }
    
    return sum % 10 == 0;
}

- (BOOL)isPartiallyValid
{
    return [self isValid] || _number.length < [self lengthForCardType];
}

- (NSInteger)lengthForCardType
{
    CCSCardType type = self.cardType;
    NSInteger length;
    if (type == CCSCardTypeAmex) {
        length = 15;
    } else if (type == CCSCardTypeDinersClub) {
        length = 14;
    } else {
        length = 16;
    }
    return length;
}

@end

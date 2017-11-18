//
//  CCSCardCVC.m
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import "CCSCardCVC.h"

@implementation CCSCardCVC {
@private
    NSString *_cvc;
}

+ (instancetype)cardCVCWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        // Strip non-digits
        if (string) {
            _cvc = [string stringByReplacingOccurrencesOfString:@"\\D"
                                                     withString:@""
                                                        options:NSRegularExpressionSearch
                                                          range:NSMakeRange(0, string.length)];
        } else {
            _cvc = [NSString string];
        }
    }
    return self;
}

- (NSString *)string
{
    return _cvc;
}

- (BOOL)isValid
{
    return _cvc.length >= 3 && _cvc.length <= 4;
}

- (BOOL)isValidWithType:(CCSCardType)type
{
    if (type == CCSCardTypeAmex) {
        return _cvc.length == 4;
    } else {
        return _cvc.length == 3;
    }
}

- (BOOL)isPartiallyValid
{
    return _cvc.length <= 4;
}

- (BOOL)isPartiallyValidWithType:(CCSCardType)type
{
    if (type == CCSCardTypeAmex) {
        return _cvc.length <= 4;
    } else {
        return _cvc.length <= 3;
    }
}

@end

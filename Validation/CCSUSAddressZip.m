//
//  CCSUSAddressZip.m
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import "CCSUSAddressZip.h"

@implementation CCSUSAddressZip {
@private
    NSString *_zip;
}

- (id)initWithString:(NSString *)string
{
    if (self = [super init]) {
        // Strip non-digits
        _zip = string;
    }
    return self;
}

- (BOOL)isValid
{
    //return _zip.length == 5;
    
    return ((_zip.length == 5) && [self valid]);
    
}

- (BOOL)isPartiallyValid
{
    return _zip.length <= 5;
}

- (BOOL)valid
{
    bool returnValue = false;
    NSString *zipcodeExpression = @"^[0-9]{5}(-/d{4})?$"; //U.S Zip ONLY!!!
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:zipcodeExpression options:0 error:NULL];
    
    NSTextCheckingResult *match = [regex firstMatchInString:_zip options:0 range:NSMakeRange(0, [_zip length])];
    if (match)
    {
        returnValue = true;
    }
    return returnValue;
}

@end

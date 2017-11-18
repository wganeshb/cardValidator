//
//  CCSAddressZip.m
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import "CCSAddressZip.h"

@implementation CCSAddressZip

+ (instancetype)addressZipWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

- (instancetype)initWithString:(NSString *)string
{
    if (self = [super init]) {
        //_zip = [string copy];
        
        _zip = [string stringByReplacingOccurrencesOfString:@"\\s"
                                                 withString:@""
                                                    options:NSRegularExpressionSearch
                                                      range:NSMakeRange(0, string.length)];
        
    }
    return self;
}

- (NSString *)string
{
    return _zip;
}

- (BOOL)isValid
{
    /*
     NSString *stripped = [_zip stringByReplacingOccurrencesOfString:@"\\s"
     withString:@""
     options:NSRegularExpressionSearch
     range:NSMakeRange(0, _zip.length)];
     */
    
    return _zip.length > 2;
}

- (BOOL)isPartiallyValid
{
    return _zip.length < 10 && _zip.length>0;
}


@end

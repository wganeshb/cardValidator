//
//  CCSCardNumber.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSCardType.h"
#import "CCSComponent.h"

@interface CCSCardNumber : CCSComponent

@property (nonatomic, readonly) CCSCardType cardType;
@property (nonatomic, readonly) NSString *last4;
@property (nonatomic, readonly) NSString *lastGroup;
@property (nonatomic, readonly) NSString *string;
@property (nonatomic, readonly) NSString *formattedString;
@property (nonatomic, readonly) NSString *formattedStringWithTrail;

@property (nonatomic, readonly, getter = isValid) BOOL valid;
@property (nonatomic, readonly, getter = isValidLength) BOOL validLength;
@property (nonatomic, readonly, getter = isValidLuhn) BOOL validLuhn;
@property (nonatomic, readonly, getter = isPartiallyValid) BOOL partiallyValid;

+ (instancetype)cardNumberWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

@end

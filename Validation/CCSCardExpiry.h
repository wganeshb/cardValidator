//
//  CCSCardExpiry.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSComponent.h"

@interface CCSCardExpiry : CCSComponent

@property (nonatomic, readonly) NSUInteger month;
@property (nonatomic, readonly) NSUInteger year;
@property (nonatomic, readonly) NSString *formattedString;
@property (nonatomic, readonly) NSString *formattedStringWithTrail;

+ (instancetype)cardExpiryWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;
- (BOOL)isValidLength;
- (BOOL)isValidDate;

@end

//
//  CCSComponent.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>

// Abstract class; represents a component of a credit card.
@interface CCSComponent : NSObject

- (id)initWithString:(NSString *)string;
- (NSString *)string;
- (NSString *)formattedString;
- (BOOL)isValid;

// Whether the value is valid so far, even if incomplete (useful for as-you-type validation).
- (BOOL)isPartiallyValid;

// The formatted value with trailing spaces inserted as needed (such as after groups in the credit card number).
- (NSString *)formattedStringWithTrail;

@end

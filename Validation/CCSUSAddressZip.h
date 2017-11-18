//
//  CCSUSAddressZip.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSAddressZip.h"

@interface CCSUSAddressZip : CCSAddressZip

- (id)initWithString:(NSString *)string;
- (BOOL)isValid;
- (BOOL)isPartiallyValid;

@end

//
//  CCSCardCVC.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSCardType.h"
#import "CCSComponent.h"

@interface CCSCardCVC : CCSComponent

@property (nonatomic, readonly) NSString *string;

+ (instancetype)cardCVCWithString:(NSString *)string;
- (BOOL)isValidWithType:(CCSCardType)type;
- (BOOL)isPartiallyValidWithType:(CCSCardType)type;

@end

//
//  CCSAddressZip.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCSComponent.h"

@interface CCSAddressZip : CCSComponent {
@protected
    NSString *_zip;
}

@property (nonatomic, readonly) NSString *string;

+ (instancetype)addressZipWithString:(NSString *)string;
- (instancetype)initWithString:(NSString *)string;

@end

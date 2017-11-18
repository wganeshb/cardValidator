//
//  CCSCard.h
//  iOSCardCaptureScreen
//
//  Created by Ganesh Waghmode on 07/06/17.
//  Copyright © 2017 ganesh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CCSCard : NSObject

@property (nonatomic, copy) NSString *number;
@property (nonatomic, copy) NSString *cvc;
@property (nonatomic, copy) NSString *addressZip;
@property (nonatomic, assign) NSUInteger expMonth;
@property (nonatomic, assign) NSUInteger expYear;

@property (nonatomic, readonly) NSString *last4;

@end

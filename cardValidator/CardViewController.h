#import <UIKit/UIKit.h>

#import "Constants.h"
#import "RequestHandler.h"

#import "CCSCard.h"
#import "CCSCardNumber.h"
#import "CCSCardExpiry.h"
#import "CCSCardCVC.h"
#import "CCSAddressZip.h"
#import "CCSUSAddressZip.h"

@protocol CardSuccessDelegateProtocol <NSObject>

-(void)onSuccess:(NSDictionary *)response;

@end

@interface CardViewController : UIViewController <RequestHandlerDelegate>

@property(nonatomic, strong)id <CardSuccessDelegateProtocol> cardSuccessDelegate;


@property (nonatomic, readonly) CCSCardNumber *cardNumber;
@property (nonatomic, readonly) CCSCardExpiry *cardExpiry;
@property (nonatomic, readonly) CCSCardCVC *cardCVC;
@property (nonatomic, readonly) CCSAddressZip *addressZip;


@end

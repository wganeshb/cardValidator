
#import <Foundation/Foundation.h>

#import "Constants.h"

@protocol RequestHandlerDelegate <NSObject>

@optional
-(void)callBackAuthorizationProcess:(NSDictionary*)dictionary;
-(void)showErrorAlertWithTitle:(NSString *)title Message:(NSString *)message;
-(void)showErrorAlertWithMessage:(NSString *)errorMessage;

@end

@interface RequestHandler : NSObject <NSURLConnectionDelegate>

@property(nonatomic, strong)id <RequestHandlerDelegate> requestHandlerDelegate;

-(id)initWithDelegate:(id)delegate;
- (void)request:(NSString *)url ofType:(NSString *)requestType withdata:(NSDictionary *)requestData;

@end

#import "RequestHandler.h"

@implementation RequestHandler
{
    NSURLConnection *connection;
    NSData *jsonData;
    NSMutableData *responseData;
}

#pragma mark - Initializer

-(id)initWithDelegate:(id)delegate {
    
    self = [super init];
    
    if (self) {
        self.requestHandlerDelegate = delegate;
    }
    return self;
}

#pragma mark - Web request

-(NSData *)postDataFromJson:(NSDictionary *)dictionary {
    
    NSError *jsonSerializationError = nil;
    jsonData = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:&jsonSerializationError];
    
    if(!jsonSerializationError) {
        
        return jsonData;
        
    } else
    {
        
    }
    return nil;
}

- (void)request:(NSString *)url ofType:(NSString *)requestType withdata:(NSDictionary *)requestData {
    
    if (connection != nil) {
        connection = nil;
    }
    
    NSData *postData = [self postDataFromJson:requestData];
    
    //(json/reply/CreateKeySessionRequest)
    //(json/reply/TokenizeCardRequest)
    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@",BaseUrl,url];
    
    NSURL *projectsUrl = [NSURL  URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:projectsUrl cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    [request setHTTPMethod:requestType];
    [request setValue:@"application/json; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[postData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody: postData];
    connection = [[NSURLConnection alloc]initWithRequest:request delegate:self];
    responseData=[NSMutableData data];
}

#pragma mark - NSURLConnection delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Response Error::%@",[error localizedDescription]);
    
    [self.requestHandlerDelegate showErrorAlertWithTitle:@"Alert" Message:[error localizedDescription]];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    [self parseAndTakeAction:res];
    
}

#pragma mark - Parse

-(void)parseAndTakeAction:(NSDictionary *)responseDictionary {
    
    
    if (![[responseDictionary valueForKey:@"ErrorMessage"] isEqualToString:@"Success"]) {
        
        NSString *errorCode = [responseDictionary valueForKey:@"ErrorCode"];
        NSString *errorMessage = [responseDictionary valueForKey:@"ErrorMessage"];
        
        [self.requestHandlerDelegate showErrorAlertWithTitle:errorCode Message:errorMessage];
        
    }
    else {
        [self.requestHandlerDelegate callBackAuthorizationProcess:responseDictionary];
    }
    
    
    
    
}




@end

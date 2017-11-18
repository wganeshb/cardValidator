#import "CardViewController.h"

@interface CardViewController () <UITextFieldDelegate>
{
    //NSArray *fieldsArray;
    BOOL _isValidState;
}
@property (weak, nonatomic) IBOutlet UITextField *cardNumberField;
@property (weak, nonatomic) IBOutlet UITextField *monthField;
@property (weak, nonatomic) IBOutlet UITextField *yearField;
@property (weak, nonatomic) IBOutlet UITextField *cvvField;
@property (weak, nonatomic) IBOutlet UITextField *zipField;
@property (weak, nonatomic) IBOutlet UIImageView *cardLogoImageView;

@property (weak, nonatomic) IBOutlet UILabel *errorMessage;

@end

@implementation CardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [_cardNumberField becomeFirstResponder];
    
    //UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Visa2.png"]];
    //[self.view addSubview:imageView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib {
    [super awakeFromNib];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self setUpNavigationBarOptions];
    NSLog(@"Data received from previous vc : %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"Session"]);
}

#pragma mark - Creating bar buttons

-(void)setUpNavigationBarOptions {
    
    self.title = @"Add Card";
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(save)];
    self.navigationItem.rightBarButtonItem = saveButton;
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelOperation)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
}


#pragma mark - User actions

-(void)cancelOperation {
    
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Session"]) {
        [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"Session"];
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)save {
    
    RequestHandler *requestHandler = [[RequestHandler alloc]initWithDelegate:self];
    requestHandler.requestHandlerDelegate = self;
    
    [requestHandler request:CREATE_REQUEST_URL ofType:@"POST" withdata:[self postData]];
}


#pragma mark -  Methods to collect the post data dictionaries


-(NSDictionary *)postData {
    
    //avs
    NSDictionary *avs = [[NSDictionary alloc]initWithObjectsAndKeys:@"",@"Address",@"",@"City",@"",@"State",@"30339",@"Zip",@"",@"Country", nil];
    
    //card expiration date
    NSString *expiration;
    if (self.monthField.text) {
        expiration = [self.monthField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
    }
    else {
        NSLog(@"date is mandatory");
    }
    
    
    NSCharacterSet *dontWantChar = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *encryptedCardNumber = [[self.cardNumberField.text componentsSeparatedByCharactersInSet:dontWantChar] componentsJoinedByString:@""];
    
    NSString *keyId;
    if ([[NSUserDefaults standardUserDefaults]valueForKey:@"Session"]) {
        
        NSDictionary *defaults = [[NSUserDefaults standardUserDefaults]valueForKey:@"Session"];
        keyId = [defaults valueForKey:@"KeyId"];
    }
    
    NSString *encryptedCVN = [self.cvvField.text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    
    NSDictionary *authDataDictionary = [[NSDictionary alloc]initWithObjectsAndKeys:keyId, @"KeyId", encryptedCardNumber, @"EncryptedCardNumber", expiration, @"Expiration", encryptedCVN, @"EncryptedCVN", avs, @"AVS",@"false", @"VerifyCard", nil];
    
    return authDataDictionary;
}




#pragma mark - RequestHandlerDelegate

-(void)callBackAuthorizationProcess:(NSDictionary *)dictionary {
    
    NSLog(@"Response from the second request : %@", dictionary);
    
    [self.cardSuccessDelegate onSuccess:dictionary];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)showErrorAlertWithMessage:(NSString *)errorMessage {
    
    UIAlertController * alert =   [UIAlertController
                                   alertControllerWithTitle:@"Alert"
                                   message:errorMessage
                                   preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                         }];
    
    [alert addAction:ok];
    
}

-(void)showErrorAlertWithTitle:(NSString *)title Message:(NSString *)message {
    
    self.errorMessage.text = message;
    
}



#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.cardNumberField]) {
        return [self cardNumberFieldShouldChangeCharactersInRange:range replacementString:string];
    }
    
    if ([textField isEqual:self.monthField]) {
        return [self cardExpiryShouldChangeCharactersInRange:range replacementString:string];
    }
    
    if ([textField isEqual:self.cvvField]) {
        return [self cardCVCShouldChangeCharactersInRange:range replacementString:string];
    }
    
    return YES;
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}


#pragma mark - new validation classes

- (NSString *)textByRemovingUselessSpacesFromString:(NSString *)string
{
    return [string stringByReplacingOccurrencesOfString:kPTKTextFieldSpaceChar withString:@""];
}

- (BOOL)cardNumberFieldShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cardNumberField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    CCSCardNumber *cardNumber = [CCSCardNumber cardNumberWithString:resultString];
    
    if (![cardNumber isPartiallyValid])
        return NO;
    
    if (replacementString.length > 0) {
        self.cardNumberField.text = [cardNumber formattedStringWithTrail];
    } else {
        self.cardNumberField.text = [cardNumber formattedString];
    }
    
    [self setPlaceholderToCardType];
    
    if ([cardNumber isValid]) {
        [self textFieldIsValid:self.cardNumberField];
        [self.monthField becomeFirstResponder];
        
    } else if ([cardNumber isValidLength] && ![cardNumber isValidLuhn]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:YES];
        
    } else if (![cardNumber isValidLength]) {
        [self textFieldIsInvalid:self.cardNumberField withErrors:NO];
    }
    
    return NO;
}

- (BOOL)cardExpiryShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.monthField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    CCSCardExpiry *cardExpiry = [CCSCardExpiry cardExpiryWithString:resultString];
    
    if (![cardExpiry isPartiallyValid]) return NO;
    
    // Only support shorthand year
    if ([cardExpiry formattedString].length > 5) return NO;
    
    if (replacementString.length > 0) {
        self.monthField.text = [cardExpiry formattedStringWithTrail];
    } else {
        self.monthField.text = [cardExpiry formattedString];
    }
    
    if ([cardExpiry isValid]) {
        [self textFieldIsValid:self.monthField];
        [self stateCardCVC];
        
    } else if ([cardExpiry isValidLength] && ![cardExpiry isValidDate]) {
        [self textFieldIsInvalid:self.monthField withErrors:YES];
    } else if (![cardExpiry isValidLength]) {
        [self textFieldIsInvalid:self.monthField withErrors:NO];
    }
    
    return NO;
}


- (BOOL)cardCVCShouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)replacementString
{
    NSString *resultString = [self.cvvField.text stringByReplacingCharactersInRange:range withString:replacementString];
    resultString = [self textByRemovingUselessSpacesFromString:resultString];
    CCSCardCVC *cardCVC = [CCSCardCVC cardCVCWithString:resultString];
    CCSCardType cardType = [[CCSCardNumber cardNumberWithString:self.cardNumberField.text] cardType];
    
    // Restrict length
    if (![cardCVC isPartiallyValidWithType:cardType]) return NO;
    
    // Strip non-digits
    self.cvvField.text = [cardCVC string];
    
    if ([cardCVC isValidWithType:cardType]) {
        [self textFieldIsValid:self.cvvField];
        [self.zipField becomeFirstResponder];
    } else {
        [self textFieldIsInvalid:self.cvvField withErrors:NO];
    }
    
    return NO;
}

- (void)stateCardCVC
{
    [self.cvvField becomeFirstResponder];
}

- (void)setPlaceholderToCardType
{
    CCSCardNumber *cardNumber = [CCSCardNumber cardNumberWithString:self.cardNumberField.text];
    CCSCardType cardType = [cardNumber cardType];
    NSString *cardTypeName = @"placeholder";
    
    switch (cardType) {
        case CCSCardTypeAmex:
            cardTypeName = @"amex";
            break;
        case CCSCardTypeDinersClub:
            cardTypeName = @"diners";
            break;
        case CCSCardTypeDiscover:
            cardTypeName = @"discover";
            break;
        case CCSCardTypeJCB:
            cardTypeName = @"jcb";
            break;
        case CCSCardTypeMasterCard:
            cardTypeName = @"mastercard";
            break;
        case CCSCardTypeVisa:
            cardTypeName = @"visa";
            break;
        default:
            break;
    }
    
    NSBundle *bundle = [NSBundle bundleForClass:[CardViewController class]];
    
    UIImage *imageFromMyLibraryBundle = [UIImage imageWithContentsOfFile:[[bundle resourcePath] stringByAppendingPathComponent:cardTypeName]];
    
    [self setPlaceholderViewImage:imageFromMyLibraryBundle];
    
}

- (void)setPlaceholderViewImage:(UIImage *)image
{
    self.cardLogoImageView.image = image;
    
    
}

#pragma mark - Validations

- (void)checkValid
{
    if ([self isValid]) {
        _isValidState = YES;
        
        NSLog(@"Card is valid : %@",self.cardNumber.last4);
        
    } else if (![self isValid] && _isValidState) {
        _isValidState = NO;
        
        NSLog(@"The card is invalid");
    }
}

- (BOOL)isValid
{
    return [self.cardNumber isValid] && [self.cardExpiry isValid] &&
    [self.cardCVC isValidWithType:self.cardNumber.cardType];
}


- (void)textFieldIsValid:(UITextField *)textField
{
    [self checkValid];
}

- (void)textFieldIsInvalid:(UITextField *)textField withErrors:(BOOL)errors
{
    if (errors) {
    } else {
    }
    
    [self checkValid];
}









@end

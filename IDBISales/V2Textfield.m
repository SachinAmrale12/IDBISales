//
//  V2Textfield.m
//  V2CompomentsInternal
//
//  Created by Sachin Amrale on 5/20/16.
//  Copyright © 2016 V2Solutions. All rights reserved.
//

#import "V2Textfield.h"
#import "UIColor+V2Color.h"

#define V2TextFieldBorderWidth 1.0f
#define V2TextFieldCornerRadius 2.0f
#define V2TFVCDefaultText @"This is default text"
#define V2TFVCZIPCodeText @"ZIP Code"
#define V2TFVCPhoneNumberText @"Phone Number"


@interface V2Textfield()

@property (strong, nonatomic) UIToolbar *pickerToolBar;

@end

@implementation V2Textfield

- (void)commonInit
{
    if (self) {
        self.delegate = self;
        datePickerView = [[UIDatePicker alloc]init];
//        self.layer.cornerRadius = V2TextFieldCornerRadius;
//        self.layer.masksToBounds=YES;
//        self.layer.borderWidth= V2TextFieldBorderWidth;
        self.borderColors = @[[UIColor V2TextFieldBorderColor1],[UIColor V2TextFieldBorderColor2]];
        [self updateSelf];
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:V2TFVCDefaultText attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldDefaultPlaceHolderTextColor]}];
        self.secureTextEntry = false;
        self.textColor = [UIColor V2TextFieldTextColor];
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 45)];
        self.leftView = paddingView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
        
    }
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithStatus:(V2TextFieldStatus)status
{
    self = [super init];
    if (self) {
        [self commonInit];
        [self setStatus:status];
    }
    return self;
}

- (id)initWithStyle:(V2TextFieldStyle)style
{
    self = [super init];
    if (self) {
        [self commonInit];
        [self setStyle:style];
    }
    return self;
}

- (void) setStatus:(V2TextFieldStatus)status{
    _status = status;
    [self updateSelf];
}

- (void) setStyle:(V2TextFieldStyle)style{
    if (style != _style) {
        _style = style;
    }
    
    [self updateStyle];
}

- (void) setPlaceHolderString:(NSString *)placeHolderString{
    if (![placeHolderString isEqualToString:_placeHolderString]) {
        _placeHolderString = placeHolderString;
    }
}


-(void) updateStyle
{
    switch (self.style) {
            
        case V2TextFieldStyleDatePicker:
        {
            self.delegate = self;
            self.text = @"";
            self.leftView = nil;
            UILabel *defaultPaddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,15,45)];
            self.leftView = defaultPaddingLabel;
            self.leftViewMode = UITextFieldViewModeAlways;
            UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"downarrow"]];
            
            UIView *rightPaddingForTextField = [[UIView alloc] initWithFrame:CGRectMake(0, 0 ,30,8)];
            [rightPaddingForTextField addSubview:imageView];
            
            self.layer.borderColor = [UIColor V2DatePickerTextFieldBorderColor].CGColor;
            self.layer.borderWidth = 1.0f;
        
            self.rightViewMode = UITextFieldViewModeAlways;
            self.rightView = rightPaddingForTextField;
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"MM / DD / YYYY" attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldPlaceHolderTextColor]}];
           
        }
            break;
        case V2TextFieldStylePicker:
        {
            self.leftView = nil;
            UILabel *defaultPaddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,15,45)];
            self.leftView = defaultPaddingLabel;
            self.leftViewMode = UITextFieldViewModeAlways;
            self.delegate = self;
            self.text = @"";
            self.placeholder = NULL;
            
            
        }
            break;

        case V2TextFieldStyleUserName:
        {
            self.text = @"";
            self.textColor = [UIColor V2TextFieldTextColor];
            self.rightView = nil;
            self.inputMaskString = nil;
            self.keyboardType = UIKeyboardTypeDefault;
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:V2TFVCDefaultText attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldDefaultPlaceHolderTextColor]}];
        }
            break;
        case V2TextFieldStylePasswordWithBottomBorder:
        {
            self.delegate = self;
            self.textFieldImage = [UIImage imageNamed:@"passwordImage"];
           // UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0 ,45,24)];
            self.textColor = [UIColor V2TextFieldPlaceHolderTextColor];
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor V2PasswordTextFieldTextColor]}];
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = TRUE;
            
            UIImageView *leftIcon = [[UIImageView alloc] initWithImage:self.textFieldImage];
            leftIcon.frame = CGRectMake(0, 0, self.textFieldImage.size.width+15, self.frame.size.height);
            leftIcon.contentMode = UIViewContentModeLeft;
            [self setLeftViewMode:UITextFieldViewModeAlways];
            self.leftView = leftIcon;
            self.autocorrectionType = UITextAutocorrectionTypeNo;
            self.inputMaskString = nil;
        }
            break;
        case V2TextFieldStylePassword:
        {
            self.delegate = self;
            UIView *leftPadding = [[UIView alloc] initWithFrame:CGRectMake(0, 0.0 ,45,24)];
            self.textColor = [UIColor V2TextFieldPlaceHolderTextColor];
            self.backgroundColor = [UIColor whiteColor];
            
            self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Password" attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldPlaceHolderTextColor]}];
            self.keyboardType = UIKeyboardTypeDefault;
            self.secureTextEntry = TRUE;
            //self.layer.borderColor = [[UIColor whiteColor] CGColor];
            self.layer.borderWidth= V2TextFieldBorderWidth;
            self.layer.cornerRadius = 0.0;
            self.borderStyle = UITextBorderStyleNone;
            
            [self setLeftViewMode:UITextFieldViewModeAlways];
            self.inputMaskString = nil;
        
        }
            break;
            
        case V2TextFieldStyleDefault:
        case V2TextFieldStyleZipcode:
        case V2TextFieldStylePhoneNumber:
        default:
        {
            self.text = @"";
            self.textColor = [UIColor V2TextFieldTextColor];
          //  UILabel *defaultPaddingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 ,15,45)];
          //  self.leftView = defaultPaddingLabel;
            self.rightView = nil;
            
            self.borderStyle = UITextBorderStyleLine;
            self.layer.borderColor = [self.borderColors[0] CGColor];
            self.inputMaskString = nil;
            self.layer.borderWidth= V2TextFieldBorderWidth;
            
            if (self.style == V2TextFieldStyleZipcode){
                self.delegate = self;
                self.keyboardType = UIKeyboardTypeNumberPad;
                self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:V2TFVCZIPCodeText attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldDefaultPlaceHolderTextColor]}];
                
            }else if (self.style == V2TextFieldStylePhoneNumber){
                self.delegate = self;
                self.keyboardType = UIKeyboardTypeNumberPad;
                self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:V2TFVCPhoneNumberText attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldDefaultPlaceHolderTextColor]}];
            }
            else {
                self.keyboardType = UIKeyboardTypeDefault;
                self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:V2TFVCDefaultText attributes:@{NSForegroundColorAttributeName: [UIColor V2TextFieldDefaultPlaceHolderTextColor]}];
            }
        }
            break;
    }
}


-(void)setBorderToTextField:(V2TextFieldBorder )vBorder withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth
{
    CALayer *border = [[CALayer alloc]init];
    
    switch (vBorder) {
        case Left:
            border.backgroundColor = borderColor.CGColor;
            border.frame = CGRectMake(0, 0, borderWidth, self.frame.size.height);
            break;
            
        case Right:
            border.backgroundColor = borderColor.CGColor;
            border.frame = CGRectMake(self.frame.size.width - borderWidth, 0, borderWidth, self.frame.size.height);
            break;
            
        case Top:
            border.backgroundColor = borderColor.CGColor;
            border.frame = CGRectMake(0, 0, self.frame.size.width,borderWidth);
            break;
            
        case Bottom:
            border.backgroundColor = borderColor.CGColor;
            border.frame = CGRectMake(0, self.frame.size.height - borderWidth, self.frame.size.width,borderWidth);
            break;
            
        case All:
            self.layer.borderWidth = borderWidth;
            self.layer.borderColor = borderColor.CGColor;
            break;
            
        default:
            break;
    }
    
    [self.layer addSublayer:border];
}



- (void) updateSelf
{
    self.layer.borderColor = [self.borderColors[self.status] CGColor];
}


- (void)formatInput:(UITextField*)aTextField string:(NSString*)aString range:(NSRange)aRange
{
    //Copying the contents of UITextField to an variable to add new chars later
    NSString* value = aTextField.text;
    
    NSString* formattedValue = value;
    
    //Make sure to retrieve the newly entered char on UITextField
    aRange.length = 1;
    
    NSString* _mask = [self.inputMaskString substringWithRange:aRange];
    
    //Checking if there's a char mask at current position of cursor
    if (_mask != nil) {
        NSString *regex = @"[0-9]*";
        
        NSPredicate *regextest = [NSPredicate
                                  predicateWithFormat:@"SELF MATCHES %@", regex];
        //Checking if the character at this position isn't a digit
        if (! [regextest evaluateWithObject:_mask]) {
            //If the character at current position is a special char this char must be appended to the user entered text
            formattedValue = [formattedValue stringByAppendingString:_mask];
        }   
        
        if (aRange.location + 1 < [self.inputMaskString length]) {
            _mask =  [self.inputMaskString substringWithRange:NSMakeRange(aRange.location + 1, 1)];
            if([_mask isEqualToString:@" "])
                formattedValue = [formattedValue stringByAppendingString:_mask];
        }
    }
    //Adding the user entered character
    formattedValue = [formattedValue stringByAppendingString:aString];
    
    //Refreshing UITextField value
    aTextField.text = formattedValue;
}

- (void)setText:(NSString *)string For:(UITextField*)aTextField
{
    aTextField.text  = [aTextField.text stringByAppendingString:string];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self resignFirstResponder];
}

- (NSDate *)convertDateFromstring:(NSString *)textField dateFormatter:(NSDateFormatter *)dateFormatter {
    NSError *error = nil;
    NSRegularExpression *regex =[NSRegularExpression regularExpressionWithPattern:@" / " options:NSRegularExpressionCaseInsensitive error:&error];
    
    // Replace the matches
    NSString *modifiedString =
    [regex stringByReplacingMatchesInString:textField
                                    options:0
                                      range:NSMakeRange(0, [textField length])
                               withTemplate:@"/"];
    
    NSDate *date = [dateFormatter dateFromString: modifiedString];
    return date;
}


-(void)addDatePickerToTextField
{
    datePickerView.datePickerMode = UIDatePickerModeDate;
    datePickerView.maximumDate = [NSDate date];
    self.inputView = datePickerView;
    [datePickerView addTarget:self action:@selector(handleDatePicker:) forControlEvents:UIControlEventValueChanged];
}

-(void)handleDatePicker:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *date = [(UIDatePicker *)sender date];
    self.text = [dateFormatter stringFromDate:date];
}

-(void)addButtonToPickerTextField
{
    UIToolbar *toolBar = [[UIToolbar alloc]init];
    toolBar.barStyle = UIBarStyleDefault;
    [toolBar sizeToFit];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(donePicker)];
    
    [toolBar setItems:@[cancelButton,spaceButton,doneButton] animated:false];
    toolBar.userInteractionEnabled = true;
    self.inputView = datePickerView;
    self.inputAccessoryView = toolBar;
    
}

-(void)donePicker{
    [self resignFirstResponder];
}


- (void) textFieldDidBeginEditing:(UITextField *)textField
{
    if (self.style == V2TextFieldStyleDatePicker) {
        [self addDatePickerToTextField];
        [self addButtonToPickerTextField];
    }
    if (self.style == V2TextFieldStyleUserName || self.style == V2TextFieldStylePasswordWithBottomBorder) {
        [self setBorderToTextField:Bottom withBorderColor:[UIColor V2TextFieldBlueBottomColor] withBorderWidth:1];
    }

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    if ([self.text length] || range.location == 0) {
        if (string) {
            if(! [string isEqualToString:@""]) {
                [self formatInput:textField string:string range:range];
                return NO;
            }
            return YES;
        }
        return YES;
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [textField layoutIfNeeded];
    NSString *trimmedString = [textField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    textField.text = trimmedString;
    
    if (self.style == V2TextFieldStyleUserName || self.style == V2TextFieldStylePasswordWithBottomBorder) {
        [self setBorderToTextField:Bottom withBorderColor:[UIColor V2TextFieldGrayBottomColor] withBorderWidth:1];
    }
    
}


@end

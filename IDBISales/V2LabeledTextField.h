//
//  V2LabeledTextField.h
//  V2CompomentsInternal
//
//  Created by Sachin Amrale on 5/23/16.
//  Copyright © 2016 V2Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "V2Textfield.h"

typedef NS_ENUM(NSUInteger,V2LabeledTextFieldStyle){
    V2LabeledTextFieldStyleDefault,
    V2LabeledTextFieldStylePassword,
    V2LabeledTextFieldStylePhoneNumber,
    V2LabeledTextFieldStyleZipCode,
    V2LabeledTextFieldStyleDatePicker
};


@interface V2LabeledTextField : UIControl<UITextFieldDelegate>

@property (nonatomic, assign) V2TextFieldStatus status;
@property (nonatomic, assign) V2LabeledTextFieldStyle style;
@property (nonatomic, strong) IBOutlet UILabel *label;
@property (nonatomic, strong) IBOutlet V2Textfield *textField;
@property (nonatomic , strong) UIDatePicker *datePicker;


@end

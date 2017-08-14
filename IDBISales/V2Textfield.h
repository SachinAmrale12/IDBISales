//
//  V2Textfield.h
//  V2CompomentsInternal
//
//  Created by Sachin Amrale on 5/20/16.
//  Copyright © 2016 V2Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSUInteger,V2TextFieldStatus){
    V2TextFieldStatusDefault,
    V2TextFieldStatusError
};

typedef NS_ENUM(NSUInteger,V2TextFieldStyle){
    V2TextFieldStyleDefault,
    V2TextFieldStylePassword,
    V2TextFieldStylePhoneNumber,
    V2TextFieldStyleZipcode,
    V2TextFieldStyleDatePicker,
    V2TextFieldStyleUserName,
    V2TextFieldStylePicker,
    V2TextFieldStylePasswordWithBottomBorder
};

typedef NS_ENUM(NSUInteger, V2TextFieldBorder) {
    Left,
    Right,
    Top,
    Bottom,
    All
};


@interface V2Textfield : UITextField<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,UIActionSheetDelegate>
{
    UIDatePicker *datePickerView;
}

@property (nonatomic, assign) V2TextFieldStatus status;
@property (nonatomic, assign) V2TextFieldStyle style;
@property (nonatomic, copy) NSArray* borderColors;
@property (strong, nonatomic) NSString *placeHolderString;
@property (nonatomic , strong ) NSString *inputMaskString;
@property (nonatomic , strong) UIImage *textFieldImage;
@property (nonatomic , strong) UIDatePicker *datePicker;
@property (strong, nonatomic) NSDate *startDate;

-(void)setBorderToTextField:(V2TextFieldBorder )vBorder withBorderColor:(UIColor *)borderColor withBorderWidth:(CGFloat)borderWidth;

@end

//
//  V2LabeledTextField.m
//  V2CompomentsInternal
//
//  Created by Sachin Amrale on 5/23/16.
//  Copyright © 2016 V2Solutions. All rights reserved.
//

#import "V2LabeledTextField.h"
#import "UIColor+V2Color.h"

#define V2TextLabelFieldBorder 0.0f

@interface V2LabeledTextField ()

@property (weak, nonatomic) IBOutlet UIView *ContainerView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightImageSpaceWidth;
@property (strong, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImageSpaceWidth;


@end

@implementation V2LabeledTextField

- (void)commonInit
{
    if (self) {
        
        [[NSBundle mainBundle] loadNibNamed:@"V2LabeledTextField" owner:self options:nil];
        [self addSubview:self.view];
        [self setUpConstraints];
        [self updateSelf];
        
    }
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
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
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}


- (void)setUpConstraints{
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    UIView *subview = self.view;
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    
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
- (void) setStyle:(V2LabeledTextFieldStyle)style{
    
    if (style != _style) {
        _style = style;
        [self updateStyle];
    }
}
- (void) setStatus:(V2TextFieldStatus)status
{
    //    if (status != _status) {
    _status = status;
    [self updateSelf];
    //    }
}

-(void) updateStyle
{
    switch (self.style) {
        case V2LabeledTextFieldStyleDatePicker:
        {
            self.rightImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.leftImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.ContainerView.backgroundColor = [UIColor whiteColor];
            self.textField.style = V2TextFieldStyleDatePicker;
        }
            break;
        case V2LabeledTextFieldStyleZipCode:
        {
            self.rightImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.leftImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.ContainerView.backgroundColor = [UIColor whiteColor];
            self.textField.style = V2TextFieldStyleZipcode;
            
            
        }
            break;
        case V2LabeledTextFieldStylePassword:
        {
            self.rightImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.leftImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.ContainerView.backgroundColor = [UIColor whiteColor];
            self.textField.style = V2TextFieldStylePassword;
            
            
        }
            break;
        case V2LabeledTextFieldStylePhoneNumber:
        {
            self.rightImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.leftImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.ContainerView.backgroundColor = [UIColor whiteColor];
            self.textField.style = V2TextFieldStylePhoneNumber;
            
            
        }
            break;
        default:
        {
            self.rightImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.leftImageSpaceWidth.constant = V2TextLabelFieldBorder;
            self.ContainerView.backgroundColor = [UIColor whiteColor];
            self.textField.style = V2TextFieldStyleDefault;
        }
            break;
    }
    
}


- (void) updateSelf
{
    
    self.textField.layer.borderColor = [self.textField.borderColors[self.status] CGColor];
    if (self.status == V2TextFieldStatusError) {
        [self.label setTextColor:self.textField.borderColors[self.status]];
        
    } else {
        self.label.textColor = [UIColor V2LebeledTextColor];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


@end

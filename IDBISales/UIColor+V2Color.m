//
//  UIColor+V2Color.m
//  V2CompomentsInternal
//
//  Created by ashok.londhe on 15/06/16.
//  Copyright © 2016 V2Solutions. All rights reserved.
//

#import "UIColor+V2Color.h"

@implementation UIColor (V2Color)

+ (UIColor *)V2TextFieldTextColor

{
    return [UIColor colorWithRed:0.22 green:0.22 blue:0.22 alpha:1];
}

+ (UIColor *)V2TextFieldBorderColor1{
    return  [UIColor colorWithRed:83.0f/255.0f green:152.0f/255.0f blue:232.0f/255.0f alpha:1.0f];
}

+ (UIColor *)V2TextFieldBorderColor2{
    return  [UIColor colorWithRed:206.0f/255.0f green:115.0f/255.0f blue:84.0f/255.0f alpha:1.0f];
}

+ (UIColor *)V2DatePickerTextFieldBorderColor{
    return [UIColor colorWithRed:118.0f/255.0f green:186.0f/255.0f blue:235.0f/255.0f alpha:1.0f];
}

+ (UIColor *)V2TextFieldPlaceHolderTextColor{
    return [UIColor colorWithRed:205.0f/255.0f green:205.0f/255.0f blue:205.0f/255.0f alpha:1.0f];
}

+ (UIColor *)V2PasswordTextFieldTextColor{
    return [UIColor colorWithRed:140.0f/255.0f green:180.0f/255.0f blue:71.0f/255.0f alpha:1.0f];
}

+ (UIColor *)V2TextFieldDefaultPlaceHolderTextColor{
    return [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
}

+ (UIColor *)V2LebeledTextColor{
    return [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

+ (UIColor *)V2NavigationBarBlueColor{
    return [UIColor colorWithRed:39.0/255.0 green:131.0/255.0 blue:186.0/255.0 alpha:1.0];
}

+ (UIColor *)V2TextFieldBlueBottomColor{
    return [UIColor colorWithRed:2.0/255.0 green:153.0/255.0 blue:211.0/255.0 alpha:1.0];
}

+ (UIColor *)V2TextFieldGrayBottomColor{
    return [UIColor colorWithRed:109.0/255.0 green:109.0/255.0 blue:109.0/255.0 alpha:1.0];
}

+ (UIColor *)V2AlertViewButtonColor{
    return [UIColor blackColor];
}

+ (UIColor *)V2AlertViewButtonTitleColor{
    return [UIColor whiteColor];
}

+ (UIColor *)V2AlertViewCancelButtonTitleColor{
    return [UIColor whiteColor];
}

+ (UIColor *)V2AlertViewCancelTitleColor{
    return [UIColor blackColor];
}

+ (UIColor *)V2AlertViewMessageColor{
    return [UIColor blackColor];;
}

+ (UIColor *)V2AlertViewTitleColor{
    return [UIColor colorWithRed:0.42f green:0.78 blue:0.32f alpha:1.0f];;
}


#pragma mark -Tour Screen

+ (UIColor *)V2PageBackgroundGreenColor
{
    return [UIColor colorWithRed:0.48 green:0.75 blue:0.26 alpha:1];
}

+ (UIColor *)V2PageBackgroundLightGreenColor
{
    return [UIColor colorWithRed:0.65 green:0.82 blue:0.51 alpha:1];
}

+ (UIColor *)V2PageBackgroundBlueColor
{
    return [UIColor colorWithRed:0.4 green:0.8 blue:0.89 alpha: 1];
}

+ (UIColor *)V2PageTitleAndInfoColor
{
    return [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha: 1];
}




@end

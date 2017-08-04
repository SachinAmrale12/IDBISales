//
//  KeyCode.m
//  EncryptionUsingJava
//
//  Created by Amit Dhadse on 27/04/16.
//  Copyright © 2016 IDBI Intech. All rights reserved.
//

#import "KeyCode.h"

@implementation KeyCode



+ (KeyCode*)sharedInstance
{
    static KeyCode *_sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[KeyCode alloc] init];
        
    });
    
    return _sharedInstance;
}

-(NSString*)getKey:(NSString*)custID withMobile:(NSString*)MobileNumber;
{
    NSString *finalchar;
    NSInteger cust_Size;
   NSMutableArray* finalString=[[NSMutableArray alloc] init];
    NSMutableString* EncryptionString=[[NSMutableString alloc] init];
    
   NSMutableArray *  AlternateArray=[[NSMutableArray alloc] init];
   NSMutableArray * custidarr=[[NSMutableArray alloc] init];
   NSMutableArray* custidTemparr=[[NSMutableArray alloc] init];
   NSMutableArray*  mobilearr=[[NSMutableArray alloc] init];
   NSMutableArray*  CusttArray=[[NSMutableArray alloc] init];
    
    
    [AlternateArray removeAllObjects];
    [custidarr removeAllObjects];
    [custidTemparr removeAllObjects];
    [mobilearr removeAllObjects];
    [CusttArray removeAllObjects];
    
    
    
    
    
    for (int m=0; m<[custID length]; m++)
    {
        NSString *SingleCharacter  = [NSString stringWithFormat:@"%c", [custID characterAtIndex:m]];
        [CusttArray addObject:SingleCharacter];
        
    }
    
    //   CusttArray=@[@"7",@"1",@"4",@"7",@"2",@"0",@"8",@"6"];
    
    finalchar=@"";
    
    
    for (int i = 0; i < [custID length]; i++) {
        [custidTemparr addObject:[NSString stringWithFormat:@"%c", [custID characterAtIndex:i]]];
    }
    
    cust_Size=[custidTemparr count];
    int i=0;
    int j=0;
    while (j< 10)
    {
        custidarr[j]=custidTemparr[i];
        if(i==(cust_Size - 1))
        {
            i = -1;
        }
        i++;
        j++;
    }
    
    custidTemparr = nil;
    NSString *reverseMobileNumber=[self reveseString:MobileNumber];
    //  char mobilearr[] = (new StringBuilder().append(mobileNo).reverse().toString()).toCharArray();
    
    for (int i = 0; i < [reverseMobileNumber length]; i++)
    {
      
        [mobilearr addObject:[NSString stringWithFormat:@"%c", [reverseMobileNumber characterAtIndex:i]]];
    }
    
    NSInteger lastindxofmobiletemp=[mobilearr count]-1;
    NSString *lastindxofmobile=[NSString stringWithFormat:@"%@",[mobilearr objectAtIndex:lastindxofmobiletemp]];
    //lastindxofmobile
    
    
    for (int k=0; k<[custidarr count]; k++)
    {
        int valueofCustomerArray=[(NSNumber *)[custidarr objectAtIndex:k] intValue];
        int lengthogAddtion=valueofCustomerArray + [lastindxofmobile intValue];
        
        NSString *intttosting=[NSString stringWithFormat:@"%d",lengthogAddtion];
        NSInteger index=[intttosting length]-1;
        
        NSString *converttostring=[NSString stringWithFormat:@"%d",lengthogAddtion];
        const char *arr=[converttostring cStringUsingEncoding:NSUTF8StringEncoding];
        NSString *finalOBject=[NSString stringWithFormat:@"%c",arr[index]];
        [custidarr replaceObjectAtIndex:k withObject:finalOBject];
        
        
        
    }
    
    NSInteger lastindxofCustomerID=[CusttArray count]-1;
    NSString *lastindxofCustomer=[NSString stringWithFormat:@"%@",[CusttArray objectAtIndex:lastindxofCustomerID]];
    
    
    for (int k=0; k<[mobilearr count]; k++)
    {
        int valueofMobileNumberArray=[(NSNumber *)[mobilearr objectAtIndex:k] intValue];
        int lengthogAddtion=valueofMobileNumberArray + [lastindxofCustomer intValue];
        
        NSString *intttosting=[NSString stringWithFormat:@"%d",lengthogAddtion];
        NSInteger indexofCustomer=[intttosting length]-1;
        
        NSString *converttostring=[NSString stringWithFormat:@"%d",lengthogAddtion];
        const char *arr=[converttostring cStringUsingEncoding:NSUTF8StringEncoding];
        
        NSString *finalOBject=[NSString stringWithFormat:@"%c",arr[indexofCustomer]];
        [mobilearr replaceObjectAtIndex:k withObject:finalOBject];
        
      
        
        
    }
    
    
    int l=0,k=0;
    while (k<31)
    {
        AlternateArray[k]=mobilearr[l];
        k++;
        AlternateArray[k]=custidarr[l];
        if(l==9)
        {
            l=-1;
        }
        l++;
        k++;
    }
    k=0;
    
    while (k<31)
    {
        NSString *c1=AlternateArray[k];
        k++;
        NSString *c2=AlternateArray[k];
        k++;
//        
//        int charVal = Integer.parseInt(String.valueOf(c1)
//                                       + String.valueOf(c2));
//        if (charVal <= 10) {
//            charVal = 99;
//        } else if (charVal > 10 && charVal <= 20) {
//            charVal = 60;
//        }else if(charVal > 20 && charVal <= 30){
//            charVal=125;
//        }else if(charVal > 30 && charVal < 33){
//            charVal=126;
//        }
//        finalchar += String.valueOf((char) charVal);
//        
        
        NSString *combinestring=[NSString stringWithFormat:@"%@%@",c1,c2];
      //  [finalString appendString:[NSString stringWithFormat:@"%@",c1]];
      //  [finalString appendString:[NSString stringWithFormat:@"%@",c2]];
        [finalString addObject:combinestring];
        
        int converttoInt=[[finalString objectAtIndex:0] intValue];
        if (converttoInt <= 10)
        {
                converttoInt = 99;
            
        } else if (converttoInt > 10 && converttoInt <= 20)
        {
                converttoInt = 56;
            
        }else if(converttoInt > 20 && converttoInt <= 30)
        {
                converttoInt=97;
            
        }else if(converttoInt > 30 && converttoInt < 33)
        {
                converttoInt=83;
        }
        
        
        [EncryptionString appendString:[NSString stringWithFormat:@"%d",converttoInt]];
        [finalString removeAllObjects];
       
    }
    
     NSString *test=[self returnKey:EncryptionString];
  
    

    
    
    
    
    
    
    return test;
}



-(NSString *)returnKey:(NSString *)value
{
    NSString *string1;
    NSString *string2;
    NSString *string3 = @"";
    for (int i=0; i<value.length-1;) {
        string1 = [value substringWithRange:NSMakeRange(i, 2)];
        string2 = [NSString stringWithFormat:@"%c", string1.intValue];
        string3 = [string3 stringByAppendingString:string2];
        i = i+2;
    }
    return string3;
}



-(NSString *)reveseString:(NSString *)plainString
{
    NSMutableString *reversedString = [NSMutableString string];
    NSInteger charIndex = [plainString length];
    while (charIndex > 0) {
        charIndex--;
        NSRange subStrRange = NSMakeRange(charIndex, 1);
        [reversedString appendString:[plainString substringWithRange:subStrRange]];
    }
    return reversedString;
}









@end

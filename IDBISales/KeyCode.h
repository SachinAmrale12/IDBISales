//
//  KeyCode.h
//  EncryptionUsingJava
//
//  Created by Amit Dhadse on 27/04/16.
//  Copyright © 2016 IDBI Intech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KeyCode : NSObject

-(NSString*)getKey:(NSString*)custID withMobile:(NSString*)MobileNumber;
+ (KeyCode*)sharedInstance;
@end

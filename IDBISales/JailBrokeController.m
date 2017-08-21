//
//  JailBrokeController.m
//  I-Varsity
//
//  Created by Amit Dhadse on 02/12/15.
//  Copyright (c) 2015 IDBI Intech. All rights reserved.
//

#import "JailBrokeController.h"

@interface JailBrokeController ()

@end

@implementation JailBrokeController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIAlertView *jailBrokeAlert=[[UIAlertView alloc] initWithTitle:@"MESSAGE" message:@"THIS APPLICATION NOT OPEN ON JAILBROKEN DEVICES" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [jailBrokeAlert show];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

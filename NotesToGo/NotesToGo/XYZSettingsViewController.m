//
//  XYZSettingsViewController.m
//  NotesToGo
//
//  Created by Raymond Clark on 6/26/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import "XYZSettingsViewController.h"

@interface XYZSettingsViewController ()

@end

@implementation XYZSettingsViewController

- (IBAction)contactUsButton:(id)sender {
    NSString *emailTitle = @"FutureNote Support";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"raymondclarkfuturenote@gmail.com"];
    
    MFMailComposeViewController *messageController = [[MFMailComposeViewController alloc] init];
    messageController.mailComposeDelegate = self;
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [messageController setSubject:emailTitle];
    [messageController setMessageBody:messageBody isHTML:NO];
    [messageController setToRecipients:toRecipents];
    [self presentViewController:messageController animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

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
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
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

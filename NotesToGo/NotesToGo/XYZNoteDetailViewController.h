//
//  XYZNoteDetailViewController.h
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZAddNoteViewController.h"
#import "XYZNotesTableViewController.h"

@interface XYZNoteDetailViewController : UIViewController <UIAlertViewDelegate, UITextViewDelegate, UIScrollViewDelegate>

@property (weak,nonatomic) IBOutlet UITextView *detailTextView;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *shareButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak,nonatomic) IBOutlet UIToolbar *detailTextViewToolbar;
@property XYZNote *noteInfo;

-(IBAction)shareButtonActivityView:(id)sender;
-(IBAction)doneButtonClickedDismissKeyboard:(id)sender;



@end

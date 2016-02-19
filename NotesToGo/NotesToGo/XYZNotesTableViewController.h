//
//  XYZNotesTableViewController.h
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYZNoteDetailViewController.h"
#import "XYZAddNoteViewController.h"
#import "XYZNote.h"

@interface XYZNotesTableViewController : UITableViewController

@property NSMutableArray *notesArray;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *addNoteButton;
@property (weak,nonatomic) IBOutlet UIBarButtonItem *contactUsButton;

-(IBAction)unwindToList:(UIStoryboardSegue *)segue;
-(IBAction)saveButtonPressed:(UIStoryboardSegue *)segue;

-(void)saveData;


@end

//
//  XYZNotesTableViewController.m
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import "XYZNotesTableViewController.h"

@interface XYZNotesTableViewController ()

@end

@implementation XYZNotesTableViewController

@synthesize addNoteButton;

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)loadData {
    NSURL *data = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:[data path]])
    {
        self.notesArray = [[NSKeyedUnarchiver unarchiveObjectWithFile:[data path]] mutableCopy];
    }
    else
    {
        self.notesArray = [[NSMutableArray alloc] init];
    }
    
    /*if(self.notesArray.count == 0) {
        NSLog(@"notesArray contains %lu notes", self.notesArray.count);
    }
    
    if(self.notesArray.count > 0) {
        NSLog(@"notesArray contains %lu notes", self.notesArray.count);
    }*/
}

-(void)saveData {
    NSURL *data = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SavedData"];
    [NSKeyedArchiver archiveRootObject:self.notesArray toFile:[data path]];
    NSLog(@"Data Saved");
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"showNote"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        XYZNoteDetailViewController *detailViewController = segue.destinationViewController;
        detailViewController.noteInfo = [self.notesArray objectAtIndex:indexPath.row];
        
    }
}

-(void)welcomeMessage {
    XYZNote *welcomeNote = [[XYZNote alloc] init];
    welcomeNote.noteName = @"Welcome to FutureNote! \n\nThe aim of FutureNote is to provide you with an easy to use note taking app.  But wait...as you use this app, think of things that can be included to streamline effeciency and user friendliness.  If you contact us with your requests, we will do our best to include your suggestions into future updates.  Truly make this app yours!";
    [self.notesArray insertObject:welcomeNote atIndex:0];
}


-(IBAction)unwindToList:(UIStoryboardSegue *)segue {
    NSLog(@"segue");
    XYZAddNoteViewController *source = [segue sourceViewController];
    XYZNote *item = source.note;
    
    if(item != nil) {
        [self.notesArray insertObject:item atIndex:0];
        [self saveData];
        [self.tableView reloadData];
    }
    
}

/**********************************************************************
 * V1.0.2 CHANGED SAVING TO UPDATE TO INDEXPATH.ROW INSTEAD OF INDEX:0
 **********************************************************************/

//-(IBAction)saveButtonPressed:(UIStoryboardSegue *)segue {
//    XYZNoteDetailViewController *source = [segue sourceViewController];
//    XYZNote *item = source.noteInfo;
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    
//    
//    if(item.noteName != source.detailTextView.text) {
//        [self.notesArray removeObjectAtIndex:indexPath.row];
//        [self.notesArray insertObject:item atIndex:indexPath.row];
//        [self saveData];
//        
//        [self.tableView reloadData];
//    }
//}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadData];

    
    
    // Uncomment the following line to preserve selection between presentations.
    //self.clearsSelectionOnViewWillAppear = NO;
    
    //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.editButtonItem.tintColor = [UIColor whiteColor];
    addNoteButton.tintColor = [UIColor whiteColor];

}

/*******************************************************************************************
 * V1.0.2 ADDED CONDITIONAL SUPPORT FOR TOGGLING ADDNOTEBUTTON BASED ON STATE OF EDIT BUTTON
 *******************************************************************************************/

-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
    [super setEditing:editing animated:animated];
    
    if (editing) {
        NSLog(@"Editing!");
        self.addNoteButton.enabled = false;
    }
    else {
        NSLog(@"Not editing!");
        self.addNoteButton.enabled = true;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.notesArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MyCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    XYZNote *toDoItem = [self.notesArray objectAtIndex:indexPath.row];
    cell.textLabel.text = toDoItem.noteName;
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [self.notesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self saveData];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}


/*********************************************
 * V1.0.2 ADDED SUPPORT FOR REARRANGING ROWS
 *********************************************/

 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
     NSString *objectToRearrange = [self.notesArray objectAtIndex:fromIndexPath.row];
     [self.notesArray removeObjectAtIndex:fromIndexPath.row];
     [self.notesArray insertObject:objectToRearrange atIndex:toIndexPath.row];
     [self saveData];
                               
 }




 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
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
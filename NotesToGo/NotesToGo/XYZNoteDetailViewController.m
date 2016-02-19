//
//  XYZNoteDetailViewController.m
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import "XYZNoteDetailViewController.h"

@interface XYZNoteDetailViewController ()

@end

@implementation XYZNoteDetailViewController

@synthesize detailTextView;
@synthesize saveButton;
@synthesize noteInfo;
@synthesize shareButton;
@synthesize doneButton;
@synthesize detailTextViewToolbar;


-(BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    return YES;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    NSLog(@"Text View is editing");
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView {
    return YES;
    
}

-(void)textViewDidEndEditing:(UITextView *)textView {
    NSLog(@"Text View did end editing");

}

-(void)textViewDidChange:(UITextView *)textView {
    //NSLog(@"Text View is changing");
    self.saveButton.tintColor = [UIColor purpleColor];
    
    XYZNotesTableViewController *controller = [[XYZNotesTableViewController alloc] init];
    NSIndexPath *path = [controller.tableView indexPathForSelectedRow];
    
        noteInfo.noteName = detailTextView.text;
        NSLog(@"Note info: %@", noteInfo.noteName);
        NSLog(@"textView text: %@", detailTextView.text);
        [controller.notesArray removeObjectAtIndex:path.row];
        [controller.notesArray insertObject:noteInfo atIndex:path.row];
        [controller saveData];
        [controller.tableView reloadData];
    
    if(detailTextView.text.length == 0) {
        [controller.notesArray removeObjectAtIndex:path.row];
        [controller saveData];
        [controller.tableView reloadData];
    }
    

}

-(IBAction)doneButtonClickedDismissKeyboard:(id)sender
{
    [detailTextView resignFirstResponder];
}


-(IBAction)shareButtonActivityView:(id)sender {

    NSString *textString = self.detailTextView.text;
    NSArray *objectsToShare = @[textString];
    UIActivityViewController *activityView = [[UIActivityViewController alloc] initWithActivityItems:objectsToShare applicationActivities:nil];
    [self presentViewController:activityView animated:YES completion:nil];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidShow:)
                                                 name: UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector (keyboardDidHide:)
                                                 name: UIKeyboardDidHideNotification object:nil];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];


	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.detailTextView];
}

- (void)keyboardDidShow:(NSNotification *)aNotification
{
	[self adjustViewForKeyboardReveal:YES notificationInfo:[aNotification userInfo]];
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
}


- (void)keyboardDidHide:(NSNotification *)aNotification
{
    [self adjustViewForKeyboardReveal:NO notificationInfo:[aNotification userInfo]];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
}


/******************************************
 * V1.0.2 ACCOMODATED FOR TOOLBAR FOR TEXT
 ******************************************/

- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard notificationInfo:(NSDictionary *)notificationInfo
{
    // the keyboard is showing so resize the text view's height
	CGRect keyboardRect = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.detailTextView.frame;
    
    // note the keyboard rect's width and height are reversed in landscape
    NSInteger adjustDelta = UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetHeight(keyboardRect) : keyboardRect.size.width;
    
    if (showKeyboard)
        frame.size.height -= (adjustDelta - 43);  //added in 43 to account for toolbar at bottom of screen when keyboard appears.
    else
        frame.size.height += (adjustDelta - 43);
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.detailTextView.frame = frame;
    [UIView commitAnimations];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if(sender != self.saveButton) return;
    NSLog(@"segue alksjdflkd");
    XYZNotesTableViewController *toDoList = segue.destinationViewController;
    NSIndexPath *indexPath = [toDoList.tableView indexPathForSelectedRow];
    XYZNote *compareItem = [[XYZNote alloc] init];
    if (detailTextView.text != compareItem.noteName) {
        noteInfo.noteName = detailTextView.text;
    }
    if(detailTextView.text.length == 0) {
        [toDoList.notesArray removeObjectAtIndex:indexPath.row];
        [toDoList saveData];
        [toDoList.tableView reloadData];
    }
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

/**********************************************************************
 * V1.0.2 CHANGED LOCATION OF SHARE BUTTON
 **********************************************************************/

- (void)viewDidLoad
{
    [super viewDidLoad];
    detailTextView.delegate = self;
    detailTextView.text = noteInfo.noteName;
    shareButton.tintColor = [UIColor whiteColor];
    saveButton.tintColor = [UIColor whiteColor];
    doneButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem.enabled = NO;

    // Do any additional setup after loading the view.
}

/*-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling");
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    NSLog(@"will begin dragging");
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    NSLog(@"did end dragging");
}

-(void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    NSLog(@"scroll to top");
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSLog(@"Scroll did end decelerating");
}*/

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

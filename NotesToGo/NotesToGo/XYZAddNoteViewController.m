//
//  XYZAddNoteViewController.m
//  NotesToGo
//
//  Created by Raymond Clark on 6/19/14.
//  Copyright (c) 2014 Raymond Clark. All rights reserved.
//

#import "XYZAddNoteViewController.h"

@interface XYZAddNoteViewController ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *doneButton;

@end

@implementation XYZAddNoteViewController


-(void)addDoneToolBarToKeyboard:(UITextView *)textView
{
    UIToolbar* doneToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    doneToolbar.barStyle = UIBarStyleDefault;
    doneToolbar.items = [NSArray arrayWithObjects:
                         [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                         [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonClickedDismissKeyboard)],
                         nil];
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    [doneToolbar sizeToFit];
    textView.inputAccessoryView = doneToolbar;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.textView = textView;
}

-(void)doneButtonClickedDismissKeyboard
{
    [self.textView resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // listen for keyboard hide/show notifications so we can properly adjust the table's height
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    //[self.textView becomeFirstResponder];
    
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
	
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:self.textView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:self.textView];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UITextFieldTextDidChangeNotification
                                                  object:self.textView];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
	[self adjustViewForKeyboardReveal:YES notificationInfo:[aNotification userInfo]];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    [self adjustViewForKeyboardReveal:NO notificationInfo:[aNotification userInfo]];
}


- (void)adjustViewForKeyboardReveal:(BOOL)showKeyboard notificationInfo:(NSDictionary *)notificationInfo
{
    // the keyboard is showing so resize the text view's height
	CGRect keyboardRect = [[notificationInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval animationDuration = [[notificationInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    CGRect frame = self.textView.frame;
    
    // note the keyboard rect's width and height are reversed in landscape
    NSInteger adjustDelta =
    UIInterfaceOrientationIsPortrait(self.interfaceOrientation) ? CGRectGetHeight(keyboardRect) : keyboardRect.size.width;
    
    if (showKeyboard)
        frame.size.height -= adjustDelta;
    else
        frame.size.height += adjustDelta;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    self.textView.frame = frame;
    [UIView commitAnimations];
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if(sender != self.doneButton) return;
    if(self.textView.text.length > 0) {
        self.note = [[XYZNote alloc] init];
        self.note.noteName = self.textView.text;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addDoneToolBarToKeyboard:self.textView];

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

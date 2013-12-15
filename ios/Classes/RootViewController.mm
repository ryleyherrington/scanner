// -*- Mode: ObjC; tab-width: 2; indent-tabs-mode: nil; c-basic-offset: 2 -*-
/*
 * Copyright 2010-2012 ZXing authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#import "RootViewController.h"
#import "MultiFormatReader.h"

@implementation RootViewController

@synthesize debug;

@synthesize sendButton;
@synthesize scrollView;

@synthesize resultsView;
@synthesize resultsToDisplay;

@synthesize url;
@synthesize addInventory;
@synthesize checkin;
@synthesize checkout;

@synthesize name;
@synthesize accessories;
@synthesize borrower;
@synthesize features;
@synthesize other;
@synthesize os;
@synthesize pages;
@synthesize attributes;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [resultsView setText:resultsToDisplay];
    [scrollView flashScrollIndicators];
    
    url = @"scanner419.appspot.com";
}

- (IBAction)scanPressed:(id)sender {
	
  ZXingWidgetController *widController =
    [[ZXingWidgetController alloc] initWithDelegate:self showCancel:YES OneDMode:NO];

  NSMutableSet *readers = [[NSMutableSet alloc ] init];

  MultiFormatReader* reader = [[MultiFormatReader alloc] init];
  [readers addObject:reader];
  [reader release];
    
  widController.readers = readers;
  [readers release];
    
  NSBundle *mainBundle = [NSBundle mainBundle];
  widController.soundToPlay =
    [NSURL fileURLWithPath:[mainBundle pathForResource:@"beep-beep" ofType:@"aiff"] isDirectory:NO];

  [self presentViewController:widController animated:YES completion:nil];

  [widController release];
}

#pragma mark -
#pragma mark ZXingDelegateMethods

- (void)zxingController:(ZXingWidgetController*)controller didScanResult:(NSString *)result {
  self.resultsToDisplay = result;
  if (self.isViewLoaded) {
    [resultsView setText:resultsToDisplay];
    [resultsView setNeedsDisplay];
  }
    
  [self dismissViewControllerAnimated:NO completion:nil];
}

-(IBAction)sendIt:(id)sender{
    //NSString *message =[NSString stringWithFormat:@"%@%@%@%@%@%@%@%@%@", name.text, accessories.text, borrower.text,features.text,other.text,os.text,pages.text,attributes.text, resultsView.text];
    
    NSString *post = [NSString stringWithFormat:@"&name=%@&accessories=%@&borrower=%@&features=%@&other=%@&OS=%@&pages=%@&attributes=%@&barcode=%@",name.text, accessories.text, borrower.text,features.text,other.text,os.text,pages.text,attributes.text, resultsView.text];
    
    if (!borrower.text ||!resultsView.text){
        UIAlertView *touchAlert = [[UIAlertView alloc] initWithTitle:@"Failed" message:@"Borrower and Barcode must be filled" delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [touchAlert show];
        [touchAlert release];
    }
    NSLog(@"post:%@", post);
   
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d",[postData length]];
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    NSLog(@"%@",url);
    
    [request setURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Current-Type"];
    [request setHTTPBody:postData];

    if(borrower.text && resultsView.text && (![url isEqualToString:@"http://www.scanner419.appspot.com/insert"]))
    {
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(conn)
            NSLog(@"Connection Successful");
        else
            NSLog(@"Connection could not be made");
    }
    else if (name.text && features.text &&  resultsView.text)
    {
        NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request delegate:self];
        if(conn)
            NSLog(@"Connection Successful");
        else
            NSLog(@"Connection could not be made");
    }
}

-(IBAction)debugFill:(id)sender{
    if(![debug isOn]){
        name.text = nil;
        accessories.text = nil;
        borrower.text = nil;
        features.text = nil;
        other.text = nil;
        os.text = nil;
        pages.text = nil;
        attributes.text = nil;
        resultsView.text = nil;
    }
    else{
        name.text = @"Macbook Pro";
        accessories.text = @"accessories";
        borrower.text = @"Ryley's evil twin";
        features.text = @"13.3 inch screen";
        other.text = @"It's silver";
        os.text = @"Mac os10";
        pages.text = @"Not Applicable";
        attributes.text = @"Thin";
        resultsView.text = @"barcoooode";
    }
}

-(IBAction)addSwitchChange:(id)sender{
    [checkout setOn:NO animated:YES];
    [checkin setOn:NO animated:YES];
    [addInventory setOn:YES animated:YES];
    url = @"http://www.scanner419.appspot.com/insert";
}

-(IBAction)ciSwitchChange:(id)sender{
    [addInventory setOn:NO animated:YES];
    [checkout setOn:NO animated:YES];
    [checkin setOn:YES animated:YES];
    url = @"http://www.scanner419.appspot.com/checkin";
}

-(IBAction)coSwitchChange:(id)sender{
    [checkin setOn:NO animated:YES];
    [addInventory setOn:NO animated:YES];
    [checkout setOn:YES animated:YES];
    url = @"http://www.scanner419.appspot.com/checkout";
}

- (void)zxingControllerDidCancel:(ZXingWidgetController*)controller {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidUnload {
  self.resultsView = nil;
}

- (void)dealloc {
  [resultsView release];
  [resultsToDisplay release];
  [scrollView release];
  [sendButton release];
    [other release];
    [attributes release];
    [pages release];
    [os release];
    [debug release];
  [super dealloc];
}


@end


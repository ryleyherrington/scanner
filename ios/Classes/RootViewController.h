//
//  RootViewController.h
//  ScanTest
//
//  Created by Ryley Herrington on 10/23/2013.
//  Copyright Ryley Herrington 2013. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXingWidgetController.h"
@interface RootViewController : UIViewController <ZXingDelegate> {
  IBOutlet UITextView *resultsView;
  NSString *resultsToDisplay;
  UIScrollView *scrollView;
  NSString *url;
    
  IBOutlet UIBarButtonItem *sendButton;
  IBOutlet UISwitch *add;
  IBOutlet UISwitch *checkout;
  IBOutlet UISwitch *checkin;

  IBOutlet UITextField *name;
  IBOutlet UITextField *accessories;
  IBOutlet UITextField *borrower;
  IBOutlet UITextField *features;
  IBOutlet UITextField *other;
  IBOutlet UITextField *attributes;
  IBOutlet UITextField *pages;
  IBOutlet UITextField *os;
    
  IBOutlet UISwitch *debug;
}
@property (retain, nonatomic) IBOutlet UISwitch *debug;
-(IBAction)debugFill:(id)sender;


@property (retain, nonatomic) IBOutlet UIBarButtonItem *sendButton;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;

@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) IBOutlet UISwitch *addInventory;
@property (nonatomic, retain) IBOutlet UISwitch *checkout;
@property (nonatomic, retain) IBOutlet UISwitch *checkin;

-(IBAction)sendIt:(id)sender;
-(IBAction)addSwitchChange:(id)sender;
-(IBAction)ciSwitchChange:(id)sender;
-(IBAction)coSwitchChange:(id)sender;

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *accessories;
@property (nonatomic, retain) IBOutlet UITextField *borrower;
@property (nonatomic, retain) IBOutlet UITextField *features;
@property (nonatomic, retain) IBOutlet UITextField *other;
@property (nonatomic, retain) IBOutlet UITextField *os;
@property (nonatomic, retain) IBOutlet UITextField *pages;
@property (nonatomic, retain) IBOutlet UITextField *attributes;

@property (nonatomic, retain) IBOutlet UITextView *resultsView;
@property (nonatomic, copy) NSString *resultsToDisplay;

- (IBAction)scanPressed:(id)sender;

@end

//
//  MainTableViewController.h
//  ScanTest
//
//  Created by Ryley Herrington on 10/17/13.
//
//

#import <UIKit/UIKit.h>

@interface MainTableViewController : UITableViewController <UITableViewDataSource>
@property (nonatomic, strong) NSMutableArray *jsonDictionaries;
@property (nonatomic, strong) NSMutableArray *singleDictionary;
@end

//
//  MainTableViewController.m
//  ScanTest
//
//  Created by Ryley Herrington on 10/17/13.
//
//

#import "MainTableViewController.h"

@interface MainTableViewController ()

@end

@implementation MainTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIAlertView *touchAlert = [[UIAlertView alloc] initWithTitle:@"Info" message:@"Checkmark means it's available, otherwise it's checked out." delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [touchAlert show];
    [touchAlert release];

    [self updateTableview];
    [self.tableView reloadData];
    
    //Pull to refresh table view
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self action:@selector(updateTableview) forControlEvents: UIControlEventValueChanged];
}


- (void)updateTableview{
    NSData *jsonData = [NSData dataWithContentsOfURL:[NSURL URLWithString:@"http://scanner419.appspot.com"]];
    if (!jsonData){
        NSString *fake = @"{items: [{available: 0,name: \"Unavailable\",barcode: \"n/a\",accessories: \"none\",other: \"\",features: \"\",borrower: \"Unavailable\",date: \"\",attributes: \"\",OS: \"\",pages: \"\",history: \"\"}]}}";
        jsonData = [fake dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSError *error = nil;
    
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    self.jsonDictionaries = [json objectForKey:@"items"];
    NSLog(@"%@",self.jsonDictionaries);
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return self.jsonDictionaries.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }

    NSDictionary* item =  self.jsonDictionaries[indexPath.row];
    cell.detailTextLabel.text =[item objectForKey:@"borrower"];
    
    if ([[item objectForKey:@"available"] isEqualToNumber:[NSNumber numberWithInt:1]])
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    cell.textLabel.text = [item objectForKey:@"name"];
    if ([[item objectForKey:@"available"] isEqualToNumber:[NSNumber numberWithInt:0]]){
        cell.accessoryType = NULL;
    }
    
    return cell;
}

#pragma mark - UITableView Delegate

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary* item =  self.jsonDictionaries[indexPath.row];
    NSString *string = [item description];
    UIAlertView *touchAlert = [[UIAlertView alloc] initWithTitle:[item objectForKey:@"name"] message:string delegate:Nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
    [touchAlert show];
}

@end

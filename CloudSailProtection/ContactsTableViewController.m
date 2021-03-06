//
//  ContactsTableViewController.m
//  CloudSailProtection
//
//  Created by Ice on 12/1/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "ContactsTableViewCell.h"
#import "CSPGlobalViewControlManager.h"
#import "Post.h"
#import "Communicator.h"
#import "MBProgressHUD.h"
#import "CSPLoginViewController.h"
#import "UIStoryBoard+New.h"

@interface ContactsTableViewController ()
@property (nonatomic, strong) NSMutableArray *contactsArray;
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *errorView;

@end

@implementation ContactsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"联系方式";
    
    [self reloadCommunicators];
    
    if (self.isMenuNode)
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"navigationDummy"] style:UIBarButtonItemStylePlain target:self action:@selector(toggleMenu)];
    }
    else
    {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(closeContacts)];
    }
    
}

//create pull request to load server contacts info
- (void)reloadCommunicators
{
    self.errorView.hidden = YES;
    __block ContactsTableViewController *weakSelf = self;
    
    if (!_contactsArray)
    {
        _contactsArray = [NSMutableArray array];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        __block NSMutableArray *weakContacts = _contactsArray;
        [Post getCommunicationsInfoWithBlock:^(NSArray *communicationsArray)
        {
            if (communicationsArray && ![communicationsArray isEqual:[NSNull null]] && communicationsArray.count > 0)
            {
                [communicationsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    Communicator *comm = [[Communicator alloc]initWithCommunicatorAttribute:obj];
                    [weakContacts addObject:comm];
                }];
                [weakSelf.tableView reloadData];
            }
            else
            {
                weakSelf.errorView.hidden = NO;
            }
            
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }andFailureBlock:^{
            weakSelf.errorView.hidden = NO;
            [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        }];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view removeGestureRecognizer:self.slidingViewController.panGesture];
    
}

- (ECSlidingViewController*)slidingViewController
{
    return [[CSPGlobalViewControlManager sharedManager]rootCotrol];
}

- (void)toggleMenu
{
    [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:YES];
}


- (IBAction)phoneNumberTapped:(id)sender
{
    NSString *phonenumber = [[sender titleLabel]text];
    
    NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phonenumber]];
    [[UIApplication sharedApplication] openURL:telURL];
}

- (void)closeContacts
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_contactsArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ContactsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContactsTableViewCellIdentifier" forIndexPath:indexPath];
    [cell setValueFromContacts:_contactsArray[indexPath.row]];
    
    return cell;
}


- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    if (!self.isMenuNode)
    {
        __weak CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
        
        [self dismissViewControllerAnimated:YES completion:^{
            [transitionView didSelectTabAtIndex:index];
        }];
    }
    else
    {
        [super displayHomeViewWithTabIndex:index];
    }
    
}
@end

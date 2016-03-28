//
//  CSPMenuViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPMenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MenuNodeManager.h"
#import "MenuNode.h"
#import "UIStoryBoard+New.h"
#import "CSPLoginViewController.h"
#import "CSPGlobalConstants.h"
#import "MenuTableViewCell.h"
#import "CSPMyDevicesCollectionViewController.h"
#import "CSPAboutViewController.h"
#import "ContactsTableViewController.h"
#import "SessionManager.h"
#import "CSPTransitionsViewController.h"

@interface CSPMenuViewController ()
//left menu item title
@property (nonatomic, strong) NSArray *menuItems;
//right root default page control
@property (nonatomic, strong) UIViewController *transitionsNavigationController;

@property (nonatomic, strong) NSIndexPath *selectedPath;
@end

@implementation CSPMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // topViewController is the transitions navigation controller at this point.
    // It is initially set as a User Defined Runtime Attributes in storyboards.
    // We keep a reference to this instance so that we can go back to it without losing its state.
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    //should login to enter into the default dash board, present login view
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    //dismiss keyboards
    [self.view endEditing:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - Properties

//there are several menu items to display in left menu
//the one menu text is a menu item.
- (NSArray *)menuItems {
    if (_menuItems) return _menuItems;
    
    _menuItems = [[MenuNodeManager sharedManager]menuNodes];
    
    return _menuItems;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.menuItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuTableViewCellIdentifier";
    MenuTableViewCell *cell = (MenuTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    //title
    NSString *menuItem = [self.menuItems[indexPath.row] title];
    //menu action image
    UIImage  *menuImage = [self.menuItems[indexPath.row] nodeImage];
    
    cell.textTitle.text = menuItem;
    cell.menuImage.image = menuImage;
    if (indexPath.row != 0)
    {
        cell.extendImage.hidden = YES;
    }
    else
    {
        self.selectedPath = indexPath;
    }
    
    [cell setBackgroundColor:[UIColor clearColor]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //get menu node
    MenuNode *node = self.menuItems[indexPath.row];
    //menu title
    NSString *menuItem = [node title];
    //menu related story identifier
    NSString *menuItemIdentifier = [node controllerIdentifier];
    //is this menu need login
    BOOL isrequiredLogin = [node isLoginRequired];
    //apps login status
    BOOL loginStatus = [[SessionManager sharedManager]isLoggedIn];
    //display login control if the menu node need log in
    if (isrequiredLogin && !loginStatus)
    {
        CSPLoginViewController *login = [UIStoryboard instantiateControllerWithIdentifier:NSStringFromClass([CSPLoginViewController class])];
        [self.slidingViewController presentViewController:login animated:YES completion:nil];
        
        return;
    }
    
    // This undoes the Zoom Transition's scale because it affects the other transitions.
    // You normally wouldn't need to do anything like this, but we're changing transitions
    // dynamically so everything needs to start in a consistent state.
    self.slidingViewController.topViewController.view.layer.transform = CATransform3DMakeScale(1, 1, 1);
    
    //display default dash view if the menu item title is "首页"
    if ([menuItem isEqualToString:@"首页"])
    {
        self.slidingViewController.topViewController = self.transitionsNavigationController;
    }
    else
    {
        //display menu item related page control
        
        //get page control through menu item identifier
        UIViewController *control = [UIStoryboard instantiateControllerWithIdentifier:menuItemIdentifier];
        if ([control isKindOfClass:[ContactsTableViewController class]])
        {
            //there is a different displaying mode for contact through this attributes
            ((ContactsTableViewController*)control).isMenuNode = YES;
        }
        //root the right page control
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:control];
        //add status bar background view
        UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
        view.backgroundColor = [UIColor colorWithRed:104/255.0 green:165/255.0 blue:205/255.0 alpha:1];
        [navigationController.view addSubview:view];
        //set top page control view
        self.slidingViewController.topViewController = navigationController;
    }
    
    //close left menu page
    [self.slidingViewController resetTopViewAnimated:YES];
    
    MenuTableViewCell *previousSelectedCell = [tableView cellForRowAtIndexPath:self.selectedPath];
    MenuTableViewCell *currentSelectedCell = [tableView cellForRowAtIndexPath:indexPath];
    previousSelectedCell.extendImage.hidden = YES;
    currentSelectedCell.extendImage.hidden = NO;
    self.selectedPath = indexPath;
}

- (CSPTransitionsViewController *)getTabBarView
{
    return (CSPTransitionsViewController*)self.transitionsNavigationController;
}

- (void)displayHomeView
{
    [self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
}
@end

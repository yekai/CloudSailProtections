//
//  TabsBarBaseViewController.m
//  CloudSailProtection
//
//  Created by Ice on 3/4/16.
//  Copyright © 2016 neusoft. All rights reserved.
//

#import "TabsBarBaseViewController.h"
#import "AHTabView.h"
#import "AHSubitemView.h"
#import "CSPGlobalViewControlManager.h"
#import "CSPMenuViewController.h"
#import "CSPTransitionsViewController.h"

@interface TabsBarBaseViewController ()

@property (nonatomic, strong) NSNumber *tabBarHeight;
@property (nonatomic, strong) NSMutableArray *tabs;
@property (nonatomic, strong) UIView *tabBar;
//The separator line at the top of the tab bar
@property (nonatomic) UIView *separator;
//A 2 dimensional array that holds the initialized viewcontrollers for the subitems
@property (nonatomic) NSMutableArray *rootViewControllers;

@end

@implementation TabsBarBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMenu];
    
    self.tabBarHeight = @75;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.view setTranslatesAutoresizingMaskIntoConstraints:YES];
    //If the rootViewControllers array hasn't been initialized yet it means that we need to set up the whole tab bar
    if (!self.rootViewControllers) {
        self.rootViewControllers = [NSMutableArray arrayWithCapacity:self.tabs.count];
        for (AHTabView *t in self.tabs) {
            NSMutableArray *subitems = [NSMutableArray arrayWithCapacity:t.subitems.count];
            for (int i = 0; i < t.subitems.count; i++) {
                [subitems addObject:[NSNull null]];
            }
            [self.rootViewControllers addObject:subitems];
        }
        
        [self reloadTabBar];
        
        //Call -layoutIfNeeded here to force laying out the tabs so that
        // we can set the first tab as selected
        [self.tabBar layoutIfNeeded];
    }
}

#pragma mark - Layout
-(void)reloadTabBar
{
    //Remove old tabs if there are any
    for (AHTabView *t in self.tabBar.subviews) {
        [t removeFromSuperview];
    }
    
    //Calculate the new dimensions
    float tabwidth = self.tabBar.frame.size.width/self.tabs.count;
    
    CGRect f = CGRectMake(0, 0, self.tabBar.frame.size.width, .5f);
    if (![[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        f.size.height = 1.f;
    
    self.separator = [[UIView alloc] initWithFrame:f];
    [self.separator setBackgroundColor:[UIColor colorWithWhite:.7f alpha:1.f]];
    [self.tabBar addSubview:self.separator];
    
    //Create and add each tab to the tabBar
    for (int i = 0; i < self.tabs.count; i++) {
        CGRect tabFrame = CGRectMake(i*tabwidth, 0.f, tabwidth, self.tabBarHeight.floatValue);
        AHTabView *tabView = self.tabs[i];
        [tabView setFrame:tabFrame];
        [tabView setSelectedColor:self.selectedColor];
        __weak typeof(self) weakself = self;
        [tabView setDidSelectTab:^(AHTabView *tab) {
            [weakself didSelectTab:tab];
        }];
        [self.tabBar addSubview:tabView];
    }
}

-(UIColor *)selectedColor
{
    UIColor  *selectColor = [UIColor colorWithRed:39/255.0 green:124/255.0 blue:204/255.0 alpha:1];
    
    return selectColor;
}

- (void)didSelectTab:(AHTabView *)tab
{
    NSInteger index = [self.tabs indexOfObject:tab];
    [self displayHomeViewWithTabIndex:index];
}


#pragma mark - Properties
-(void)setupMenu
{
    /******* default dashboard *******/
    
    AHTabView *defaultDash = [AHTabView new];
    [defaultDash setImage:[UIImage imageNamed:@"homeDash"]];
    [defaultDash setTitle:@"首页"];
    
    AHSubitemView *defaultDashControl = [AHSubitemView new];
    [defaultDashControl setImage:[UIImage imageNamed:@"homeDash"]];
    [defaultDashControl setTitle:@"首页"];
    [defaultDashControl setViewControllerIdentifier:@"CSPDefaultPageViewController"];
    [defaultDash addSubitem:defaultDashControl];
    
    
    /******* cloud alarm*******/
    AHTabView *wdgz = [AHTabView new];
    [wdgz setImage:[UIImage imageNamed:@"gaoJing"]];
    [wdgz setTitle:@"告警"];
    
    AHSubitemView *wdgzControl = [AHSubitemView new];
    [wdgzControl setImage:[UIImage imageNamed:@"gaoJing"]];
    [wdgzControl setTitle:@"告警"];
    [wdgzControl setViewControllerIdentifier:@"CSPWarningViewController"];
    [wdgz addSubitem:wdgzControl];
    
    /******* break down  *******/
    AHTabView *fringilla = [AHTabView new];
    [fringilla setImage:[UIImage imageNamed:@"guZhang"]];
    [fringilla setTitle:@"故障"];
    
    AHSubitemView *fFirst = [AHSubitemView new];
    [fFirst setImage:[UIImage imageNamed:@"guZhang"]];
    [fFirst setTitle:@"故障"];
    [fFirst setViewControllerIdentifier:@"CSPBreakdownsViewController"];
    [fringilla addSubitem:fFirst];
    
    /******* Equipment Patrol and Examine *******/
    AHTabView *ipsum = [AHTabView new];
    [ipsum setImage:[UIImage imageNamed:@"nengHao"]];
    [ipsum setTitle:@"能耗"];
    
    AHSubitemView *iFirst = [AHSubitemView new];
    [iFirst setImage:[UIImage imageNamed:@"nengHao"]];
    [iFirst setTitle:@"能耗"];
    [iFirst setViewControllerIdentifier:@"CSPEnergyConsumptionPUEViewController"];
    [ipsum addSubitem:iFirst];
    
    /******* Equipment Patrol and Examine *******/
    AHTabView *xunjian = [AHTabView new];
    [xunjian setImage:[UIImage imageNamed:@"xunJian"]];
    [xunjian setTitle:@"巡检"];
    
    AHSubitemView *xunjianControl = [AHSubitemView new];
    [xunjianControl setImage:[UIImage imageNamed:@"xunJian"]];
    [xunjianControl setTitle:@"巡检"];
    [xunjianControl setViewControllerIdentifier:@"CSPRoutingViewController"];
    [xunjian addSubitem:xunjianControl];
    
    self.tabs = [NSMutableArray array];
    //Don't forget to add your AHTabView instances to the AHTabBarController!
    [self.tabs addObjectsFromArray:@[defaultDash, wdgz, fringilla, ipsum, xunjian]];
}

-(UIView *)tabBar
{
    if (!_tabBar) {
        _tabBar = [[UIView alloc] initWithFrame:CGRectMake(0.f,
                                                           self.view.bounds.size.height-self.tabBarHeight.floatValue,
                                                           self.view.bounds.size.width,
                                                           self.tabBarHeight.floatValue)];
        [_tabBar setBackgroundColor:[UIColor colorWithRed:218/255.0 green:237/255.0 blue:243/255.0 alpha:1]];
        
        self.separator = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _tabBar.frame.size.width, 1.f)];
        [self.separator setBackgroundColor:[UIColor colorWithWhite:.7f alpha:1.f]];
        [_tabBar addSubview:self.separator];
        [self.view addSubview:_tabBar];
    }
    return _tabBar;
}

- (void)displayHomeViewWithTabIndex:(NSInteger)index
{
    typeof (self) __weak weakSelf = self;
    
    [[[CSPGlobalViewControlManager sharedManager]rootCotrol] anchorTopViewToRightAnimated:NO onComplete:^{
        
        [weakSelf performSelector:@selector(displayHomeViewWithIndex:) withObject:@(index) afterDelay:0.5];
    }];
}

- (void)displayHomeViewWithIndex:(NSNumber *)index
{
    __weak CSPTransitionsViewController *transitionView = [[CSPGlobalViewControlManager sharedManager]getTransitionControl];
    __weak CSPMenuViewController *menuControl = [[CSPGlobalViewControlManager sharedManager]getMenuViewControl];
    
    [menuControl displayHomeView];
    [transitionView didSelectTabAtIndex:[index integerValue]];
}

@end

//
//  CSPTransitionsViewController.m
//  CloudSailProtection
//
//  Created by Ice on 11/13/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "CSPTransitionsViewController.h"
#import "METransitions.h"
#import "UIViewController+ECSlidingViewController.h"
#import "MEDynamicTransition.h"
#import "CSPGlobalViewControlManager.h"
#import "CSPWarningViewController.h"
#import "CSPDefaultPageViewController.h"

@interface AHTabBarController()
//reload each one tab item view
-(void)reloadViewForItem:(AHSubitemView *)subitem;
//get current selected tab view
-(AHSubitemView*)currentItem;
//get related tab view control for tab view
-(UIViewController*)viewControllerForSubitem:(AHSubitemView*)subitem;
@end

@interface CSPTransitionsViewController ()
//menu transition style
@property (nonatomic, strong) METransitions *transitions;
//tap gesture for sliging from right to left or left to right to close or open the menu page
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@end

@implementation CSPTransitionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //choose one transition style
    self.transitions.dynamicTransition.slidingViewController = self.slidingViewController;
    NSDictionary *transitionData = self.transitions.all[2];
    self.slidingViewController.delegate = transitionData[@"transition"];
    
    //set top view gesture
    self.slidingViewController.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
    self.slidingViewController.customAnchoredGestures = @[];
    
    [self setupMenu];
    
    self.tabBarHeight = @75;
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
    
    //Don't forget to add your AHTabView instances to the AHTabBarController!
    [self.tabs addObjectsFromArray:@[defaultDash, wdgz, fringilla, ipsum, xunjian]];
}


- (METransitions *)transitions {
    if (_transitions) return _transitions;
    
    _transitions = [[METransitions alloc] init];
    
    return _transitions;
}

//display or close the left page menu through pan gesture
- (UIPanGestureRecognizer *)dynamicTransitionPanGesture {
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}

//display or close the page menu through tapping on sliding menu button
- (IBAction)menuButtonTapped:(id)sender {
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

-(void)reloadViewForItem:(AHSubitemView *)subitem
{
     [super reloadViewForItem:subitem];
    
    //Removing the old view(controller)
    UIViewController *oldController = [self viewControllerForSubitem:self.currentItem];
    
    //Getting the new viewcontroller or create it if we don't have it in memory yet
    UIViewController *viewController = [self viewControllerForSubitem:subitem];
    
    [oldController viewWillDisappear:NO];
    [viewController viewWillAppear:NO];
    
    [oldController.view removeGestureRecognizer:self.dynamicTransitionPanGesture];
    [viewController.view addGestureRecognizer:self.slidingViewController.panGesture];
}

- (CSPDefaultPageViewController *)getFirstTabItem
{
    NSMutableArray *rootControls = (NSMutableArray *)[self valueForKey:@"rootViewControllers"];
    return [[rootControls objectAtIndex:0]objectAtIndex:0];
}

@end

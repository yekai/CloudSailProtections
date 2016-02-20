//
//  MenuNodeManager.m
//  CloudSailProtection
//
//  Created by Ice on 11/14/15.
//  Copyright © 2015 neusoft. All rights reserved.
//

#import "MenuNodeManager.h"
#import "MenuNode.h"

@interface MenuNodeManager()
@property (nonatomic, strong) NSMutableArray *menuNodes;
@end

@implementation MenuNodeManager

+ (instancetype)sharedManager
{
    static MenuNodeManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[MenuNodeManager alloc] init];
    });
    
    return _sharedManager;
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self setupNodes];
    }
    
    return self;
}

- (void)setupNodes
{
    if (!self.menuNodes)
    {
        _menuNodes = [[NSMutableArray alloc]init];
        
        NSDictionary *home = @{@"title":@"首页",@"identifier":@"CSPTransitionsViewController",@"isLoginRequired":@YES,@"nodeImage":[UIImage imageNamed:@"grsz"]};
        NSDictionary *personalSetting = @{@"title":@"个人设置",@"identifier":@"PersonalSettingViewController",@"isLoginRequired":@YES,@"nodeImage":[UIImage imageNamed:@"grsz"]};
        NSDictionary *notices = @{@"title":@"公告信息",@"identifier":@"CSPNoticesViewController",@"isLoginRequired":@YES,@"nodeImage":[UIImage imageNamed:@"ggxx"]};
        NSDictionary *myEquipment = @{@"title":@"我的设备",@"identifier":@"CSPMyDevicesCollectionViewController",@"isLoginRequired":@NO,@"nodeImage":[UIImage imageNamed:@"wdsb"]};
        NSDictionary *communications = @{@"title":@"联系方式",@"identifier":@"ContactsTableViewController",@"isLoginRequired":@NO,@"nodeImage":[UIImage imageNamed:@"lxfs"]};
        NSDictionary *contracts = @{@"title":@"合同信息",@"identifier":@"CSPContractViewController",@"isLoginRequired":@NO,@"nodeImage":[UIImage imageNamed:@"htxx"]};
        NSDictionary *about = @{@"title":@"关于",@"identifier":@"CSPAboutViewController",@"isLoginRequired":@NO,@"nodeImage":[UIImage imageNamed:@"about"]};
        
        
        NSArray *menuNodesArray = @[home,personalSetting,notices,myEquipment,communications,contracts,about];
        
        [menuNodesArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            MenuNode *node = [[MenuNode alloc]initNodeWithDict:obj];
            [_menuNodes addObject:node];
        }];
    }
}

- (NSMutableArray *)menuNodes
{
    return _menuNodes;
}

@end

//
//  UITableView+XXTableViewReloadViewHolder.m
//  XXTableViewReloadViewHolderDemo
//
//  Created by 朱小亮 on 2017/6/1.
//  Copyright © 2017年 朱小亮. All rights reserved.
//

#import "UITableView+XXTableViewReloadViewHolder.h"
#import <objc/runtime.h>
#import "XXReachability.h"

@interface UITableView()

/**
 tableview 没数据展示的视图
 */
@property (nonatomic, strong) UIView *placeHolderView;

/**
 没网络显示的tableheardview的视图
 */
@property (nonatomic, strong) UIView *noNetView;

/**
 tableviewHeard的原始heard
 */
@property (nonatomic, strong) UIView *originHeardView;

/**
 检测网络
 */
@property (nonatomic, strong) XXReachability *reach;
@end


@implementation UITableView (XXTableViewReloadViewHolder)


- (BOOL)enableShowNet{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEnableShowNet:(BOOL)enableShowNet{
    objc_setAssociatedObject(self, @selector(enableShowNet), [NSNumber numberWithBool:enableShowNet], OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)enableShowError{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEnableShowError:(BOOL)enableShowError{
    objc_setAssociatedObject(self, @selector(enableShowError), [NSNumber numberWithBool:enableShowError], OBJC_ASSOCIATION_ASSIGN);
}

- (UIView *)placeHolderView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceHolderView:(UIView *)placeHolderView{
    objc_setAssociatedObject(self, @selector(placeHolderView), placeHolderView, OBJC_ASSOCIATION_RETAIN);
}


- (UIView *)noNetView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNoNetView:(UIView *)noNetView{
    objc_setAssociatedObject(self, @selector(noNetView), noNetView, OBJC_ASSOCIATION_RETAIN);
}


- (UIView *)originHeardView{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setOriginHeardView:(UIView *)originHeardView{
    objc_setAssociatedObject(self, @selector(originHeardView), originHeardView, OBJC_ASSOCIATION_RETAIN);
}

- (void(^)(UITableView *))placeHolderViewAction{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setPlaceHolderViewAction:(void (^)(UITableView *))placeHolderViewAction{
    objc_setAssociatedObject(self, @selector(placeHolderViewAction), placeHolderViewAction, OBJC_ASSOCIATION_COPY);
}

- (void(^)(UITableView *))noNetViewAction{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setNoNetViewAction:(void (^)(UITableView *))noNetViewAction{
    objc_setAssociatedObject(self, @selector(noNetViewAction), noNetViewAction, OBJC_ASSOCIATION_COPY);
}

- (XXReachability *)reach{
    return objc_getAssociatedObject(self, _cmd);
}
- (void)setReach:(XXReachability *)reach{
    objc_setAssociatedObject(self, @selector(reach), reach, OBJC_ASSOCIATION_RETAIN);
}



+ (void)load{
    Class theClass = NSClassFromString(@"UITableView");
    if (theClass) {
        Method origMethod =class_getInstanceMethod(theClass, @selector(reloadData));
        if (!origMethod) {
            return;
        }
        Method altMethod =class_getInstanceMethod(theClass, @selector(xx_reloadData));
        if (!altMethod) {
            return;
        }
        method_exchangeImplementations(origMethod,altMethod);
    }

}


- (void)xx_reloadData{
    [self xx_reloadData];
    
    [self xx_initBase];
}


/**
 处理没数据和断网的视图
 */
- (void)xx_initBase{
    
    if (self.enableShowError) {
        if (!self.placeHolderView) {
            [self initPlaceHolderView];
        }
        //fixed error no data question
        [self fixedError];
    }
    
    
    if (!self.enableShowNet) return;
    
    if (!self.noNetView) {
        [self initnoNetView];
    }
    
    if (!self.originHeardView&&self.tableHeaderView&&self.tableHeaderView!=self.noNetView) {
        self.originHeardView = [self duplicate:self.tableHeaderView];
    }
  
    //fixed no network question
    if(!self.reach){
        __weak __typeof(&*self)weakSelf = self;
        // Allocate a reachability object
        self.reach = [XXReachability reachabilityForInternetConnection];
        
        // Set the blocks
        self.reach.reachableBlock = ^(XXReachability *reach)
        {
            // keep in mind this is called on a background thread
            // and if you are updating the UI it needs to happen
            // on the main thread, like this:
            
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"有网");
                [weakSelf hiddenNonetwork];
            });
        };
        
        self.reach.unreachableBlock = ^(XXReachability *reach)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"没网");
                [weakSelf showNonetwork];
            });
        };
        
        // Start the notifier, which will cause the reachability object to retain itself!
        [self.reach startNotifier];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.reach.isReachable) {
                [weakSelf hiddenNonetwork];
            }
            else{
                [weakSelf showNonetwork];
            }
        });
    }
}



- (void)showNonetwork{
    if (self.originHeardView) {
        UIView *noHeardeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.originHeardView.frame.size.height + self.noNetView.frame.size.height)];
        noHeardeView.backgroundColor = [UIColor grayColor];
        [noHeardeView addSubview:self.noNetView];
        
        UIView *tempOriginHeardView = [self duplicate:self.originHeardView];
        CGRect frame = tempOriginHeardView.frame;
        frame.origin.y+=self.noNetView.frame.size.height;
        tempOriginHeardView.frame = frame;
        
        [noHeardeView addSubview:tempOriginHeardView];
        
        self.tableHeaderView = noHeardeView;
    }
    else{
        self.tableHeaderView = self.noNetView;
    }
    
    [self reloadData];
}

- (void)hiddenNonetwork{
    if (self.originHeardView) {
        self.tableHeaderView = self.originHeardView;
    }
    else{
        self.tableHeaderView = nil;
    }
    [self reloadData];
}


- (void)fixedError{
    BOOL isEmpty = YES;
    NSInteger sections = 1;
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInTableView:)]) {
        sections = [self.dataSource numberOfSectionsInTableView:self];
    }
    for (int sectionIndex = 0;sectionIndex < sections; sectionIndex++) {
        NSInteger rows = [self.dataSource tableView:self numberOfRowsInSection:sectionIndex];
        if (rows>0) {
            isEmpty = NO;
        }
    }
    
    if (isEmpty) {
        [self addSubview:self.placeHolderView];
    }
    else{
        [self.placeHolderView removeFromSuperview];
    }
}

- (void)hiddenError{
    [self.placeHolderView removeFromSuperview];
    if (self.placeHolderViewAction) {
        self.placeHolderViewAction(self);
    }
}


- (void)initnoNetView{
    CGFloat height = 44;
    self.noNetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, height)];
    self.noNetView.backgroundColor = [UIColor colorWithRed:247/255. green:216/255. blue:176/255. alpha:1];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, height-10, height-10)];
    imageView.image = [UIImage imageWithContentsOfFile:[[self xxSourceBundle] pathForResource:@"internet" ofType:@"png"]];
    [self.noNetView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.size.width + imageView.frame.origin.x +5, 5, self.frame.size.width - 20 - height, height-10)];
    label.text = @"当前网络不可用,请检查您的网络设置";
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:15];
    [self.noNetView addSubview:label];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(noNetViewTapAction)];
    [self.noNetView addGestureRecognizer:tap];
}

- (void)noNetViewTapAction{
    if (self.noNetViewAction) {
        self.noNetViewAction(self);
    }
}



- (void)initPlaceHolderView{
    
    self.placeHolderView = [[UIView alloc] initWithFrame:self.subviews.firstObject.bounds];
    self.placeHolderView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 150, 150)];
    errorImageView.center = CGPointMake(CGRectGetWidth(self.placeHolderView.frame) / 2, CGRectGetHeight(self.placeHolderView.frame) / 2 - 100);
    errorImageView.image = [UIImage imageWithContentsOfFile:[[self xxSourceBundle] pathForResource:@"WebView_LoadFail_Refresh_Icon@2x" ofType:@"png"]];
    [self.placeHolderView addSubview:errorImageView];
    
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, errorImageView.frame.size.height+errorImageView.frame.origin.y, self.placeHolderView.frame.size.width, 60)];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.text = @"请点击重新加载";
    [self.placeHolderView addSubview:textLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenError)];
    [self.placeHolderView addGestureRecognizer:tap];
    
}


//赋值view
- (UIView *)duplicate:(UIView*)view
{
    NSData * tempArchive = [NSKeyedArchiver archivedDataWithRootObject:view];
    return [NSKeyedUnarchiver unarchiveObjectWithData:tempArchive];
}


- (NSBundle *)xxSourceBundle
{
    static NSBundle *xxSourceBundle = nil;
    if (xxSourceBundle == nil) {
        xxSourceBundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"xxSourceBundle" ofType:@"bundle"]];
    }
    return xxSourceBundle;
}
@end

























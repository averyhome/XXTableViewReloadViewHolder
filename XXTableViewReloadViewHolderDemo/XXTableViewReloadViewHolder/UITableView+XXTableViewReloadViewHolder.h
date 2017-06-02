//
//  UITableView+XXTableViewReloadViewHolder.h
//  XXTableViewReloadViewHolderDemo
//
//  Created by 朱小亮 on 2017/6/1.
//  Copyright © 2017年 朱小亮. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (XXTableViewReloadViewHolder)

/**
 点击palcehoderview的回调
 */
@property (nonatomic, copy) void (^placeHolderViewAction)(UITableView *);

/**
 点击nonetView的回调
 */
@property (nonatomic, copy) void (^noNetViewAction)(UITableView *);



@property (assign,nonatomic)BOOL enableShowNet;

@property (assign,nonatomic)BOOL enableShowError;

@end

# XXTableViewReloadViewHolder

这是一个非常简单的tableview分类  用法很简单 没有侵入性 只需拷贝到项目中 就可以 不破坏原来的tableview 不需要继承tableview

用途就是仿照微信QQ断网 在tableview上提示 自动监测  自动显示 自动消失

安装十分简单 只需 pod 'XXTableViewReloadViewHolder', '~> 1.0.0' 
或者clone下来拷贝到项目中

建议用pod安装

## Examples
![niconiconi~](https://github.com/xuxueing/XXTableViewReloadViewHolder/blob/master/demo.gif
)

#### In Objective-C

```objc
#import <UITableView+XXTableViewReloadViewHolder.h>

//项目中需要此效果的设置为yes就可以
    //断网
    self.tableView.enableShowNet = YES;
    //显示tableview无数据站位view
    self.tableView.enableShowError = YES;

    //下面是点击的回调
    [self.tableView setNoNetViewAction:^(id sender){
        
    }];
    [self.tableView setPlaceHolderViewAction:^(id sender){
        
    }];
    

```

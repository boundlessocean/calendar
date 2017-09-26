//
//  BLCalendarViewController.h
//  calendar
//
//  Created by boundlessocean on 2017/9/24.
//  Copyright © 2017年 lemon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BLCalendarModel;
@interface BLCalendarViewController : UIViewController

/** 选择的日期回调 */
@property(nonatomic,copy) void(^callBackSelectedDate)(BLCalendarModel *model);

@end

@interface BLCalendarModel : NSObject
/** 年 */
@property (nonatomic ,strong)NSString *year;
/** 月 */
@property (nonatomic ,strong)NSString *month;
/** 日 */
@property (nonatomic ,strong)NSString *day;
/** 时 */
@property (nonatomic ,strong)NSString *hour;
/** 分 */
@property (nonatomic ,strong)NSString *second;
@end

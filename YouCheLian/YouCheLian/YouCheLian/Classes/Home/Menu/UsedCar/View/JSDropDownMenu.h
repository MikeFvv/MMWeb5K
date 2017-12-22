//
//  JSDropDownMenu.h
//  JSDropDownMenu
//
//  Created by Jsfu on 15-1-12.
//  Copyright (c) 2015年 jsfu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface JSIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
// 0 左边   1 右边
@property (nonatomic, assign) NSInteger leftOrRight;
// 左边行
@property (nonatomic, assign) NSInteger leftRow;
// 右边行
@property (nonatomic, assign) NSInteger row;

- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end






#pragma mark - data source protocol
@class JSDropDownMenu;

@protocol JSDropDownMenuDataSource <NSObject>

@required
// 返回数据行数
- (NSInteger)menu:(JSDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
// 返回每行title字符
- (NSString *)menu:(JSDropDownMenu *)menu titleForRowAtIndexPath:(JSIndexPath *)indexPath;
// 返回列数
- (NSString *)menu:(JSDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional


// 默认值为1
- (NSInteger)numberOfColumnsInMenu:(JSDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end










#pragma mark - delegate
@protocol JSDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(JSDropDownMenu *)menu didSelectRowAtIndexPath:(JSIndexPath *)indexPath strID:(NSString *)strID;
@end





#pragma mark - interface
@interface JSDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <JSDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <JSDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;

@property (nonatomic, strong) NSArray *JSArrayData;

/** * *
 * 菜单的宽度将设置为屏幕宽度defaultly
 *
 * @param的起源这一观点的框架
 * @param高度菜单的高度
 *
 * “返回”菜单
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
////  返回标题行title
//- (NSString *)titleForRowAtIndexPath:(JSIndexPath *)indexPath strID:(NSString *)strID;

@end









//
//  UsedCarModel.h
//  YouCheLian
//
//  Created by Mike on 16/3/5.
//  Copyright © 2016年 Mike. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsedCarModel : NSObject
///  id
@property (nonatomic, strong) NSNumber *infoid;
///  标题
@property (nonatomic, copy) NSString *title;
///  商品类别
@property (nonatomic, copy) NSString *kind;
///  商品类别文本描述
@property (nonatomic, copy) NSString *kindText;
///  分类
@property (nonatomic, copy) NSString *type;
///  分类文本描述
@property (nonatomic, copy) NSString *typeText;
///  品牌
@property (nonatomic, copy) NSString *brand;
///  品牌文本描述
@property (nonatomic, copy) NSString *brandText;
///  价格  // 等于0 的时候就是 面议
@property (nonatomic, copy) NSString *price;
///  图片url 多张用,分割
@property (nonatomic, copy) NSString *imageUrl;
///  发布用户
@property (nonatomic, copy) NSString *userPhone;
///  发布时间
@property (nonatomic, copy) NSString *addTime;
///  详细描述
@property (nonatomic, copy) NSString *descrip;
///  省份ID
@property (nonatomic, copy) NSString *Provinceid;
///  城市ID
@property (nonatomic, copy) NSString *Cityid;
///  区域ID
@property (nonatomic, copy) NSString *areaid;
///  联系电话
@property (nonatomic, copy) NSString *contact_Phone;
///  联系人
@property (nonatomic, copy) NSString *contactName;

///  排序
@property (nonatomic, strong) NSNumber *sort_id;

///  是否认证: 0=未认证 1=认证
//@property (nonatomic, strong) NSNumber *authentication;

/// 计算 title 标题 高度
@property (nonatomic, assign) CGFloat cellTitleHeight;

/// 计算 descrip 详细描述 高度
@property (nonatomic, assign) CGFloat cellDescripHeight;


///  0未置顶  1已置顶
@property (nonatomic, strong) NSNumber *ifTop;


@end








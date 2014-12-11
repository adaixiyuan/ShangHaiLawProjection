//
//  ZXY_CityZoneVC.h
//  LawProjection
//
//  Created by 周效宇 on 14-10-15.
//  Copyright (c) 2014年 duostec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LawCityEntity;
@protocol ZXY_ChooseCityDelegate <NSObject>
- (void)userChooseCityDelegate:(LawCityEntity *)provinceEntity andCityEntity:(LawCityEntity *)cityEntity withZoneEntity:(LawCityEntity *)zoneEntity;
@end

@interface ZXY_CityZoneVC : UIViewController
@property (nonatomic,strong)id<ZXY_ChooseCityDelegate>delegate;
- (void)setLevel:(BOOL)isLevelCity;
@end

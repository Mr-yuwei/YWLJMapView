//
//  YWRoundAnnotationView.h
//  YWLJMapView
//
//  Created by NeiQuan on 16/7/27.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件

@interface YWRoundAnnotationView : BMKAnnotationView

@property(nonatomic,copy)NSString *titleText;
@property(nonatomic,copy)NSString *countText;
@end





@interface YWRectAnnotationView : BMKAnnotationView

@property(nonatomic,copy)NSString           *titleText;
@property(nonatomic,retain)UIView           *calloutView;


@end
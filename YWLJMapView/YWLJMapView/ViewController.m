//
//  ViewController.m
//  YWLJMapView
//
//  Created by NeiQuan on 16/7/27.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "ViewController.h"

#import <BaiduMapAPI_Base/BMKBaseComponent.h>//引入base相关所有的头文件
#import <BaiduMapAPI_Map/BMKMapComponent.h>//引入地图功能所有的头文件
#import <BaiduMapAPI_Search/BMKSearchComponent.h>//引入检索功能所有的头文件
#import <BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>//引入云检索功能所有的头文件
#import <BaiduMapAPI_Location/BMKLocationComponent.h>//引入定位功能所有的头文件
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>//引入计算工具所有的头文件
#import <BaiduMapAPI_Radar/BMKRadarComponent.h>//引入周边雷达功能所有的头文件

#import "YWRoundAnnotationView.h"
#import "YWPointAnnotation.h"

#define YWidth [UIScreen  mainScreen].bounds.size.width
#define YWHeight [UIScreen  mainScreen].bounds.size.height
#define kCalloutViewMargin          -8

@interface ViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKPoiSearchDelegate>
{
    UIView                       *_bottomView;
    NSMutableArray               *_mapAnnotationArray;
    NSMutableArray               *_listArray;
    BMKMapView                   *_mapView;//地图对象
    BMKLocationService           *_locationService;//定位
    BMKPoiSearch                 *_poiSearch;//检索
    BMKGeoCodeSearch             *_citySearchOption;
  
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    _mapAnnotationArray=[[ NSMutableArray alloc] init];
    _listArray=[[ NSMutableArray alloc] init];
    [self initMapView];//初始化地图
    [self initlocationService];
    [self SetBasicLocation];

}
#pragma mark --private Method--根据关键字检索
-(void)SetBasicLocation{
    
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude = 40.20  ;
    coor.longitude = 116.23;
    annotation.coordinate = coor;
    annotation.title=@"昌平";
  
    
    //39.832670 116.460370°
    BMKPointAnnotation* annotationSecond = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D Secondcoor;
    Secondcoor.latitude = 39.832670 ;
    Secondcoor.longitude = 116.460370;
    annotationSecond.coordinate = Secondcoor;
   annotationSecond.title=@"朝阳";
    [_mapView addAnnotation:annotation];
    [_mapView addAnnotation:annotationSecond];
    [_mapView mapForceRefresh];
    
    
 }

-(void)viewWillDisappear:(BOOL)animated{
    [ super viewWillDisappear:animated];
    [_mapView viewWillDisappear];
    _mapView.delegate=nil;
    _mapView=nil;
    _citySearchOption.delegate = nil; // 不用时，置nil
}
-(void)viewWillAppear:(BOOL)animated{
    
    [ super viewWillAppear:animated];
    _citySearchOption.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    [_mapView viewWillAppear];
}
#pragma mark --private Method--底部定位
-(void)initWithBottomView{
    
    UIView *view=[[ UIView alloc] initWithFrame:CGRectMake(15, YWHeight-40, YWidth-30, 30)];
    [view setBackgroundColor:[ UIColor colorWithWhite:0.7 alpha:1.0]];
    _bottomView=view;
    [self.view addSubview:view];
}
#pragma mark --private Method--初始化地图
-(void)initMapView{
    
    BMKMapView  *mapView=[[ BMKMapView alloc] initWithFrame:self.view.frame];
    mapView.mapType=BMKMapTypeStandard;
    mapView.userTrackingMode=BMKUserTrackingModeFollow;
    mapView.zoomLevel=14;
    mapView.minZoomLevel=10;
    mapView.delegate=self;
    _mapView=mapView;
    [self.view addSubview:mapView];
}
#pragma mark --private Method--定位
-(void)initlocationService{
    
    _locationService=[[BMKLocationService alloc] init];
    _locationService.desiredAccuracy=kCLLocationAccuracyBest;
    _locationService.delegate=self;
    _locationService.distanceFilter=1000;
    [_locationService startUserLocationService];
    
}
#pragma mark --private Method--添加标注数据
-(void)mapViewAddANNotations{

    for (NSInteger indexM=0; indexM<_listArray.count; indexM++)
    {
        BMKPoiInfo* poi=_listArray[ indexM];
        YWPointAnnotation* annotation = [[YWPointAnnotation alloc]initWithCoordinate:poi.pt];
        annotation.titlelable=poi.name;
        [_mapAnnotationArray addObject:annotation];//用于记录
        [_mapView addAnnotation:annotation];
        
    }
    
}
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
   if ([annotation isKindOfClass:[YWPointAnnotation class]])
   {
        YWRectAnnotationView *newAnnotationView =(YWRectAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"myAnnotation"];
        if (newAnnotationView==nil)
        {
            newAnnotationView=[[ YWRectAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        }
    
        YWPointAnnotation* Newannotation=(YWPointAnnotation*)annotation;
        newAnnotationView.titleText=[ NSString stringWithFormat:@"%@20",Newannotation.titlelable];
        newAnnotationView.canShowCallout = YES;
        newAnnotationView.draggable = YES;
       
        return newAnnotationView;
       
   }else if ([ annotation  isKindOfClass:[ BMKPointAnnotation class]]){
       
       YWRoundAnnotationView *newAnnotationView =(YWRoundAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RoundmyAnnotation"];
       if (newAnnotationView==nil)
       {
           newAnnotationView=[[ YWRoundAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"RoundmyAnnotation"];
       }
       BMKPointAnnotation* Newannotation=(BMKPointAnnotation*)annotation;
       newAnnotationView.titleText=[ NSString stringWithFormat:@"%@",Newannotation.title ];
       newAnnotationView.countText=[ NSString stringWithFormat:@"%d",arc4random()%1000];
       
      newAnnotationView.canShowCallout = NO;
      newAnnotationView.draggable = YES;
      
       
       return newAnnotationView;
       
   }
    return nil;
}
- (void)mapView:(BMKMapView *)mapView annotationView:(BMKAnnotationView *)view didChangeDragState:(BMKAnnotationViewDragState)newState
   fromOldState:(BMKAnnotationViewDragState)oldState
{
    
    
    
}
#pragma mark --private Method--当点击大头针时
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view{
    
    if ([view isKindOfClass:[YWRoundAnnotationView class]])//点击圆形标注
    {
        [_mapView   removeAnnotations:nil];
        
        if (_mapAnnotationArray.count!=0)[_mapView removeAnnotations:_mapAnnotationArray];
        
        
        BMKPointAnnotation* Newannotation=(BMKPointAnnotation*)view.annotation;
        _poiSearch=[[ BMKPoiSearch alloc] init];
        _poiSearch.delegate=self;
        BMKCitySearchOption  *SearchOption=[[BMKCitySearchOption alloc] init];
        SearchOption.city=@"北京";
        SearchOption.pageCapacity=40;
        SearchOption.keyword=Newannotation.title;;
        BOOL  success=  [_poiSearch poiSearchInCity:SearchOption];
        if (success)  NSLog(@"检索成功!");
        
        
    }else if ([ view isKindOfClass:[YWRectAnnotationView class ]]){
        
        YWRectAnnotationView *cusView = (YWRectAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint screenAnchor = [_mapView getMapStatus].targetScreenPt;
            CGPoint theCenter = CGPointMake(_mapView.bounds.size.width * screenAnchor.x, _mapView.bounds.size.height * screenAnchor.y);
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }

}
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view{
    
    
    
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}

- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResult errorCode:(BMKSearchErrorCode)errorCode{
    
    if (errorCode==BMK_SEARCH_NO_ERROR)//检索成功
    {
        BMKPoiInfo* poi = nil;
        for (NSInteger i = 0; i < poiResult.poiInfoList.count; i++)
        {
            poi = [poiResult.poiInfoList objectAtIndex:i];
            [_listArray addObject:poi];
        }
        [self mapViewAddANNotations];
    }

    
}
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
    _mapView.showsUserLocation=YES;
    [_mapView updateLocationData:userLocation];
    [_mapView setCenterCoordinate:userLocation.location.coordinate];
    [_locationService stopUserLocationService];
    
}
/******************************************定位成功 *****************************************/
#pragma mark --private Method--定位成功
- (void)didFailToLocateUserWithError:(NSError *)error
{
   // [[[ UIAlertView alloc] initWithTitle:@"" message:@"定位失败" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles: nil]show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

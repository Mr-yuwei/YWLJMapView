# YWLJMapView
利用百度地图实现自定义大头针和气泡


前言：面试的时候，面试官问做过地图自定义气泡，讲讲具体的步骤，LZ大概只是看过别人写的........,最后只能说不会，这周利用闲余时间研究一下。

###自定义大头针
----------------------------------------------------------
效果图：---->没错就是链家

![001.png](http://upload-images.jianshu.io/upload_images/1488651-acd22675f5000f79.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

----------------------------------------------------------
####具体实现方法
####1.新建YWRoundAnnotationView继承于[BMKAnnotationView](http://wiki.lbsyun.baidu.com/cms/iossdk/doc/v3_0/html/interface_b_m_k_annotation_view.html)

######YWRoundAnnotationView.h
```
@interface YWRoundAnnotationView : BMKAnnotationView
@property(nonatomic,copy)NSString *titleText;//你要展示的内容你可以根据需要添加
@property(nonatomic,copy)NSString *countText;
@end
```
######YWRoundAnnotationView.m
```
//重写写方法--->类似于tableViewCell
-(instancetype)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
if (self=[super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier])
{
[self setBounds:CGRectMake(0, 0, 45, 45)];
[self initWithContentViews];//添加子视图
}
return self;
}
```
####2.根据添加subViews
```
//背景色
CGRect rect = _contentView.bounds;
//创建Path -->类似于对话框气泡路径实现
CGMutablePathRef layerpath = CGPathCreateMutable();
CGPathMoveToPoint(layerpath, NULL, 0, 0);
CGPathAddLineToPoint(layerpath, NULL, CGRectGetMaxX(rect), 0);
CGPathAddLineToPoint(layerpath, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect));

CGPathAddLineToPoint(layerpath, NULL, 45, CGRectGetMaxY(rect));
CGPathAddLineToPoint(layerpath, NULL, 37.5, CGRectGetMaxY(rect)+5);
CGPathAddLineToPoint(layerpath, NULL, 30, CGRectGetMaxY(rect));
CGPathAddLineToPoint(layerpath, NULL, 0, CGRectGetMaxY(rect));
CAShapeLayer *shapelayer=[CAShapeLayer  layer];
UIBezierPath *path=[ UIBezierPath  bezierPathWithCGPath:layerpath];
shapelayer.path=path.CGPath;
shapelayer.fillColor=[ UIColor colorWithRed:83/255.0 green:180/255.0 blue:119/255.0 alpha:1.0].CGColor;
shapelayer.cornerRadius=5;
[_contentView.layer addSublayer:shapelayer];
//lable
UILabel *lable=[[ UILabel alloc] initWithFrame:CGRectMake(0,3, 45, 21)];
lable.textAlignment=NSTextAlignmentCenter;
lable.textColor=[ UIColor whiteColor];
lable.font=[ UIFont systemFontOfSize:11];
lable.text=@"帝都";
_titleLable=lable;
[_contentView addSubview:lable];
```
####3.实现MapView的代理方法
```
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
YWRoundAnnotationView *newAnnotationView =(YWRoundAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"RoundmyAnnotation"];
if (newAnnotationView==nil)
{
newAnnotationView=[[YWRoundAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"RoundmyAnnotation"];
}
BMKPointAnnotation* Newannotation=(BMKPointAnnotation*)annotation;
newAnnotationView.titleText=[ NSString stringWithFormat:@"%@",Newannotation.title ];
newAnnotationView.countText=[ NSString stringWithFormat:@"%d",arc4random()%1000];
newAnnotationView.canShowCallout = NO;//是否显示气泡
newAnnotationView.draggable = YES;//拖拽
return newAnnotationView;
}```
```
- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
```
----------------------------------------------------------
###自定义气泡
----------------------------------------------------------
效果图


![002.png](http://upload-images.jianshu.io/upload_images/1488651-22fcd2c4603e9c5f.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

----------------------------------------------------------
1.百度提供的方法
```
@property (nonatomic, strong)BMKActionPaopaoView* paopaoView;
/**
*初始化并返回一个BMKActionPaopaoView
*@param customView 自定义View，customView＝nil时返回默认的PaopaoView
*@return 初始化成功则返回BMKActionPaopaoView,否则返回nil
*/
- (id)initWithCustomView:(UIView*)customView;
```
```
//自定义的气泡框---->感觉这个与直接CellforRow在添加cell的属性一样吧，lZ感觉不太好。
UIImageView *imageView = [[UIImageView alloc] init];
imageView.image = [UIImage imageNamed:@"infopic13.png"];
UILabel *messageText = [[UILabel alloc]init];
BMKActionPaopaoView *pView = [[BMKActionPaopaoView alloc] initWithCustomView:imageView];
((BMKPinAnnotationView *)newAnnotationView).paopaoView = pView;
```
2.自己在[高德](http://lbs.amap.com/getting-started/map/)里面借鉴的方法与大家共享
- (void)setSelected:(BOOL)selected animated:(BOOL)animated;

```
- (void)setSelected:(BOOL)selected
{
[self setSelected:selected animated:NO];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
if (self.selected == selected)return;
if (selected)
{
if (_CalloutView == nil)
{
_CalloutView = [[YWActionPaopaoView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
_CalloutView.center = CGPointMake(CGRectGetWidth(_contentView. bounds) / 2.f + self.calloutOffset.x,-CGRectGetHeight(_CalloutView.bounds) / 2.f + self.calloutOffset.y);
UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
btn.frame = CGRectMake(10, 10, 40, 40);
[btn setTitle:@"Test" forState:UIControlStateNormal];
[btn setBackgroundColor:[UIColor whiteColor]];
[btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];

UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
name.backgroundColor = [UIColor clearColor];
name.textColor = [UIColor whiteColor];
name.text = @"Mr-yuwei";

[_CalloutView addSubview:btn];
[_CalloutView addSubview:name];

}

[self addSubview:_CalloutView];
}
else
{
[_CalloutView removeFromSuperview];
}
[super setSelected:selected animated:animated];
}

```
----------------------------------------------------------


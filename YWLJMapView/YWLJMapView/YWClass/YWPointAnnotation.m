//
//  YWPointAnnotation.m
//  YWLJMapView
//
//  Created by NeiQuan on 16/7/27.
//  Copyright © 2016年 Mr-yuwei. All rights reserved.
//

#import "YWPointAnnotation.h"

@implementation YWPointAnnotation
@synthesize title = _title;
@synthesize subtitle = _subtitle;
@synthesize titlelable = _titlelable;
@synthesize coordinate = _coordinate;
- (id)initWithCoordinate:(CLLocationCoordinate2D)coordinate
{
    if (self = [super init])
    {
        self.coordinate = coordinate;
    }
    return self;
}



@end

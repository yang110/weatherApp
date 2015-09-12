//
//  MapModel.m
//  项目三
//
//  Created by Mac on 15/9/5.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import "MapModel.h"

@implementation MapModel




-(void) setCoordinateFromAVPoint:(AVGeoPoint *)geoPoint
{
    NSNumber *num2=[geoPoint valueForKey:@"longitude"];
    double longitude=[num2 longLongValue];
    NSNumber *num= [geoPoint valueForKey:@"latitude"];
    double latitude=[num doubleValue];

    _coordinate.longitude=longitude;
    _coordinate.latitude=latitude;
}


@end

//
//  WeiboAnnotation.h
//  HWWeiBo
//
//  Created by Mac on 15/9/2.
//  Copyright (c) 2015年 杨梦佳. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>


@interface WeiboAnnotation : NSObject<MKAnnotation>



// Center latitude and longitude of the annotation view.
// The implementation of this property must be KVO compliant.
@property (nonatomic) CLLocationCoordinate2D coordinate;



// Title and subtitle for use by selection UI.
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

// Called as a result of dragging an annotation view.
- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate NS_AVAILABLE(10_9, 4_0);


@property(nonatomic) WeiboModel *weiboModel;



@end

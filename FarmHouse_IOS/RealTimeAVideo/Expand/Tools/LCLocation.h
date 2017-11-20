//
//  LCLocation.h
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/15.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol LCLocationDelegate <NSObject>

- (void)didUpdateLocation:(CLLocation *)location address:(NSString *)address;

@end


@interface LCLocation : NSObject

@property (nonatomic, weak) id<LCLocationDelegate> delegate;


- (void)startUpdatingLocation;

- (void)stopUpdatingLocation;


@end



/*
 *  GPS以及iOS系统定位获得的坐标是地理坐标系WGS1984，Web地图一般用的坐标细是投影坐标系WGS 1984 Web Mercator，国内出于相关法律法规要求，对国内所有GPS设备及地图数据都进行了加密偏移处理，代号GCJ-02，这样GPS定位获得的坐标与地图上的位置刚好对应上，特殊的是百度地图在这基础上又进行一次偏移，所以在处理系统定位坐标及相关地图SDK坐标时需要转换处理下，根据网络资源，目前有一些公开的转换算法。
 系统定位坐标显示在原生地图、谷歌地图或高德地图–WGS1984转GCJ-02
 苹果地图及谷歌地图用的都是高德地图的数据，所以这三种情况坐标处理方法一样，即将WGS1984坐标转换成偏移后的GCJ-02才可以在地图上正确显示位置。
 通过这个工具类可将iOS原生地图获取的坐标点转换为地图上正确表示的真实坐标点:
 
 使用了之后解析地名几乎没影响
 http://blog.csdn.net/qxuewei/article/details/51611627
 */

@interface FixLocation : NSObject

/**
 *  public:原生地图获取坐标转化为真实坐标
 *
 *  @param latLng 原生坐标点
 *
 *  @return 真实坐标点
 */
+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D)latLng;

@end

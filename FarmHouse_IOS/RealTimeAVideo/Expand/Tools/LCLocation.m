//
//  LCLocation.m
//  RealTimeAVideo
//
//  Created by Lemon on 17/2/15.
//  Copyright © 2017年 YiWanLian. All rights reserved.
//

#import "LCLocation.h"

@interface LCLocation ()<CLLocationManagerDelegate>

@property(nonatomic, strong) CLLocationManager *locationManager;

@end


@implementation LCLocation


- (CLLocationManager *)locationManager {
    if (!_locationManager) {
        _locationManager = [[CLLocationManager alloc] init];
        //更新位置 ()请求的时候总是授权
        _locationManager.delegate = self;
        
        /*
         extern const CLLocationAccuracy kCLLocationAccuracyBestForNavigation;导航定位
         extern const CLLocationAccuracy kCLLocationAccuracyBest;精准定位
         extern const CLLocationAccuracy kCLLocationAccuracyNearestTenMeters;精确度十米
         extern const CLLocationAccuracy kCLLocationAccuracyHundredMeters;
         extern const CLLocationAccuracy kCLLocationAccuracyKilometer;
         extern const CLLocationAccuracy kCLLocationAccuracyThreeKilometers;一英里
         
         */
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        //更新频率 10米，kCLDistanceFilterNone 任何移动都将收到通知
        _locationManager.distanceFilter = 10;
        
        //主动请求授权 如果已经授权就不再请求授权
        if ([CLLocationManager authorizationStatus] == 0) {
            [_locationManager requestWhenInUseAuthorization];
        }
        
    }
    return _locationManager;
}


- (void)startUpdatingLocation {
    [self.locationManager startUpdatingLocation];
}

- (void)stopUpdatingLocation {
    [self.locationManager stopUpdatingLocation];
}

#define mark - CLLocationManagerDelegate

/** 当有新位置可用是被调用 Required for delivery of
 *    deferred locations. 如果这个方法实现 locationManager:didUpdateToLocation:fromLocation: 将不会调用。locations是按照时间排序的数组*/
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    if (locations.count == 0) return;

    for (CLLocation *location in locations) {
        
        CLLocationCoordinate2D coordinate = [FixLocation transform:location.coordinate];
        CLLocation *fixedLocation=[[CLLocation alloc]initWithLatitude:coordinate.latitude longitude: coordinate.longitude];

        
        CLGeocoder *coder = [[CLGeocoder alloc] init];
        
        [coder reverseGeocodeLocation:fixedLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            
            if (error != nil || placemarks.count == 0) {
                // 如果有错误信息或者数组中获取地名元素数量为0
                // 说明没有找到
                return;
            }else {
                
                CLPlacemark *placeMark = [placemarks firstObject];
                
                NSArray *lines = placeMark.addressDictionary[@"FormattedAddressLines"];
                NSString *addressString = [lines firstObject];
                if ([_delegate respondsToSelector:@selector(didUpdateLocation:address:)]) {
                    [_delegate didUpdateLocation:fixedLocation address:addressString];
                }
                
            }
        }];
        
    }
}

- (void)dealloc {
    NSLog(@"!!!!!%@",self.locationManager);
}


@end




// 坐标偏移修复类，not used
@implementation FixLocation

const double a = 6378245.0;
const double ee = 0.00669342162296594323;

/**
 *  public:原生地图获取坐标转化为真实坐标
 *
 *  @param latLng 原生坐标点
 *
 *  @return 真实坐标点
 */
+ (CLLocationCoordinate2D)transform:(CLLocationCoordinate2D) latLng
{
    double wgLat = latLng.latitude;
    double wgLon = latLng.longitude;
    double mgLat;
    double mgLon;
    
    if ([self outOfChina:wgLat :wgLon ])
    {
        return latLng;
    }
    double dLat = [self transformLat:wgLon-105.0 :wgLat - 35 ];
    double dLon = [self transformLon:wgLon-105.0 :wgLat - 35 ];
    
    double radLat = wgLat / 180.0 * M_PI;
    double magic = sin(radLat);
    magic = 1 - ee * magic * magic;
    double sqrtMagic = sqrt(magic);
    dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
    dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
    mgLat = wgLat + dLat;
    mgLon = wgLon + dLon;
    CLLocationCoordinate2D loc2D ;
    loc2D.latitude = mgLat;
    loc2D.longitude = mgLon;
    
    return loc2D;
}

#pragma mark private
+ (BOOL)outOfChina:(double) lat :(double) lon
{
    if (lon < 72.004 || lon > 137.8347) {
        return true;
    }
    if (lat < 0.8293 || lat > 55.8271) {
        return true;
    }
    return false;
}

+ (double)transformLat:(double)x  :(double) y
{
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y +
    0.2 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 *sin(2.0 * x *M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 *sin(y / 3.0 *M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 *sin(y * M_PI / 30.0)) * 2.0 /
    3.0;
    return ret;
}

+ (double)transformLon:(double) x :(double) y
{
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(fabs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 /
    3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 * sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 *M_PI) + 300.0 *sin(x / 30.0 * M_PI)) * 2.0 /
    3.0;
    return ret;
}


@end


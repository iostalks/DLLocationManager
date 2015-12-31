//
//  DLLocationManager.h
//  DLLocationManager
//
//  Created by Jone on 15/12/31.
//  Copyright © 2015年 Jone. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLLocation : NSObject

@property (nonatomic) NSString *province;
@property (nonatomic) NSString *city;
@property (nonatomic) NSString *district;

- (instancetype)initLocationWithProvince:(NSString *)province city:(NSString *)city district:(NSString *)district;
@end


typedef void (^DLLocateSuccessBlock)(DLLocation *location);
typedef void (^DLLocateErrorBlock)(NSError *error);

@interface DLLocationManager : NSObject

+ (DLLocationManager *)managerLocation;

- (void)locateSuccess:(DLLocateSuccessBlock)successBlock error:(DLLocateErrorBlock)errorBlock;

@end

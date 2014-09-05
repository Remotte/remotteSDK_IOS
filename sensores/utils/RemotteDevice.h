//
//  RemotteDevice.h
//  sensores
//
//  Created by PEDRO MUÑOZ CABRERA on 25/08/14.
//  Copyright (c) 2014 jose garcia. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreBluetooth/CoreBluetooth.h>

extern NSString *const kNotificationAcelerometerValueUpdated;
extern NSString *const kNotificationGyroscopeValueUpdated;
extern NSString *const kNotificationTemperatureValueUpdated;
extern NSString *const kNotificationBarometerValueUpdated;
extern NSString *const kNotificationMagnetometerValueUpdated;
extern NSString *const kNotificationHumidityValueUpdated;
extern NSString *const kNotificationButtonsTapped;

@interface RemotteDevice : NSObject


- (instancetype)initWithManager:(CBCentralManager *)manager andPeripheral:(CBPeripheral *)peripheral;

- (void)connect;
- (void)disconnect;

@end

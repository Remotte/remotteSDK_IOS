//
//  RemotteDevice.m
//  sensores
//
//  Created by PEDRO MUÑOZ CABRERA on 25/08/14.
//  Copyright (c) 2014 jose garcia. All rights reserved.
//

#import "RemotteDevice.h"

#import "BLEUtility.h"
#import "Sensors.h"

NSString *const kNotificationAcelerometerValueUpdated = @"NotificationAcelerometerValueUpdated";
NSString *const kNotificationGyroscopeValueUpdated = @"NotificationGyroscopeValueUpdated";
NSString *const kNotificationTemperatureValueUpdated = @"NotificationTemperatureValueUpdated";
NSString *const kNotificationBarometerValueUpdated = @"NotificationBarometerValueUpdated";
NSString *const kNotificationMagnetometerValueUpdated = @"NotificationMagnetometerValueUpdated";
NSString *const kNotificationHumidityValueUpdated = @"NotificationHumidityValueUpdated";
NSString *const kNotificationButtonsTapped = @"kNotificationButtonsTapped";


@interface RemotteDevice () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) CBCentralManager *manager;
@property (nonatomic,retain)CBPeripheral *peripheral;

@property (nonatomic, strong) NSDictionary *diccionarioConfig;

@end

@implementation RemotteDevice {
    
    sensorIMU3000 *gyro;
    sensorC953A *baroSensor;
    sensorMAG3110 *magSensor;
}


- (instancetype)initWithManager:(CBCentralManager *)manager andPeripheral:(CBPeripheral *)peripheral{
    
    self = [super init];
    if (self) {
        _manager = manager;
        _peripheral = peripheral;
    }
    
    return self;
}


- (void)connect{
    
    self.manager.delegate=self;
    self.peripheral.delegate=self;
    [self.manager connectPeripheral:self.peripheral options:nil];
    self.diccionarioConfig=[BLEUtility makeSensorTagConfiguration:self.peripheral.name];
    gyro=[[sensorIMU3000 alloc] init];
    magSensor=[[sensorMAG3110 alloc] init];
    baroSensor=[[sensorC953A alloc]init];
    
}

- (void)disconnect{
    
    [self.manager cancelPeripheralConnection:self.peripheral];
    baroSensor = nil;
    magSensor = nil;
    gyro = nil;
    self.peripheral.delegate = nil;
    self.manager.delegate = nil;
}


#pragma mark - CBCentralManagerDelegate

-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %ld",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}



#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    
    NSLog(@"PERIFERICO %@ name[%@]  ERR%@", [peripheral.identifier UUIDString], peripheral.name,error);
    [BLEUtility configureService:service config:[peripheral.identifier UUIDString]];
    peripheral.delegate=self;
}
/*
 - (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(NSError *)error{
 NSLog(@"didDiscoverIncludedServicesForService---->%@   ERR%@",CFUUIDCreateString(nil, peripheral.UUID),error.localizedDescription);
 
 }
 */

-(void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
        
        NSString *str=[BLEUtility hexRepresentationWithSpaces_AS:characteristic.value space:YES];
        NSString *uuidAcelService=[BLEUtility getKeyfor:@"Accelerometer service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidTemperatureService=[BLEUtility getKeyfor:@"IR temperature service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidGiroscopioService=[BLEUtility getKeyfor:@"Gyroscope service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidBarometroService=[BLEUtility getKeyfor:@"Barometer service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidBaroData=   [BLEUtility getKeyfor:@"Barometer data UUID" fromDic:self.diccionarioConfig];
        NSString *uuidBaroConfig  =[BLEUtility getKeyfor:@"Barometer config UUID" fromDic:self.diccionarioConfig];
        NSString *uuidBaroCalibration  =[BLEUtility getKeyfor:@"Barometer calibration UUID" fromDic:self.diccionarioConfig];
        NSString *uuidMagnetometorService=[BLEUtility getKeyfor:@"Magnetometer service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidHumedadService=[BLEUtility getKeyfor:@"Humidity service UUID" fromDic:self.diccionarioConfig];
        NSString *uuidButtonsService=[BLEUtility getKeyfor:@"botones service" fromDic:self.diccionarioConfig];
    

    
        if ([[CBUUID UUIDWithString:uuidAcelService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSString *str=[NSString stringWithFormat:@"[% 0.1fG]X [% 0.1fG]Y [% 0.1fG]Z",[sensorKXTJ9 calcXValue:characteristic.value],
                           [sensorKXTJ9 calcYValue:characteristic.value],
                           [sensorKXTJ9 calcZValue:characteristic.value]];
            NSLog(@"ACELERÓMETRO [%@]",str);
#endif
            
            NSDictionary *values = @{@"x-axis":[NSNumber numberWithFloat:[sensorKXTJ9 calcXValue:characteristic.value]],
                                     @"y-axis":[NSNumber numberWithFloat:[sensorKXTJ9 calcYValue:characteristic.value]],
                                     @"z-axis":[NSNumber numberWithFloat:[sensorKXTJ9 calcZValue:characteristic.value]]};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationAcelerometerValueUpdated
                                                                object:nil
                                                              userInfo:values];
            
        } else if([[CBUUID UUIDWithString:uuidTemperatureService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"TEMPERATURA [%@]",str);
#endif
            float tAmb = [sensorTMP006 calcTAmb:characteristic.value];
            float tObj = [sensorTMP006 calcTObj:characteristic.value];
            
            NSDictionary *values = @{@"tAmb":[NSNumber numberWithFloat:tAmb],
                                     @"tObj":[NSNumber numberWithFloat:tObj]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationTemperatureValueUpdated
                                                                object:nil
                                                              userInfo:values];
         
        } else if([[CBUUID UUIDWithString:uuidGiroscopioService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"GIROSCOPIO [%@]",str);
#endif
            NSDictionary *values = @{@"x-axis":[NSNumber numberWithFloat:[gyro calcXValue:characteristic.value]],
                                     @"y-axis":[NSNumber numberWithFloat:[gyro calcYValue:characteristic.value]],
                                     @"z-axis":[NSNumber numberWithFloat:[gyro calcZValue:characteristic.value]]};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationGyroscopeValueUpdated
                                                                object:nil
                                                              userInfo:values];
        } else if([[CBUUID UUIDWithString:uuidBarometroService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"BAROMETRO [%@]",str);
#endif
            
            if([[CBUUID UUIDWithString:uuidBaroData]isEqual:characteristic.UUID]){
#ifdef DEBUG
                NSLog(@"BAROMETRO [%@]",str);
#endif
                NSDictionary *values = @{@"pressure":[NSNumber numberWithInt:[baroSensor calcPressure:characteristic.value]]};
                [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationBarometerValueUpdated
                                                                    object:nil
                                                                  userInfo:values];
            }else if([[CBUUID UUIDWithString:uuidBaroConfig]isEqual:characteristic.UUID]){
#ifdef DEBUG
                NSLog(@"BAROMETRO Config [%@]",str);
#endif
            }else if([[CBUUID UUIDWithString:uuidBaroCalibration]isEqual:characteristic.UUID]){
#ifdef DEBUG
                NSLog(@"BAROMETRO [%@]",str);
#endif
                baroSensor = [[sensorC953A alloc] initWithCalibrationData:characteristic.value];
                
                CBUUID *sUUID = [CBUUID UUIDWithString:[BLEUtility getKeyfor:@"Barometer service UUID" fromDic:self.diccionarioConfig]];
                CBUUID *cUUID = [CBUUID UUIDWithString:[BLEUtility getKeyfor:@"Barometer config UUID" fromDic:self.diccionarioConfig]];
                //Issue normal operation to the device
                uint8_t data = 0x01;
                [BLEUtility writeCharacteristic:peripheral sCBUUID:sUUID cCBUUID:cUUID data:[NSData dataWithBytes:&data length:1]];
            }
            
        }else if([[CBUUID UUIDWithString:uuidMagnetometorService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"MAGNETOMETRO [%@]",str);
#endif
            float x = [magSensor calcXValue:characteristic.value];
            float y = [magSensor calcYValue:characteristic.value];
            float z = [magSensor calcZValue:characteristic.value];
            
            NSDictionary *values = @{@"x":[NSNumber numberWithFloat:x],
                                     @"y":[NSNumber numberWithFloat:y],
                                     @"z":[NSNumber numberWithFloat:z]};
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationMagnetometerValueUpdated
                                                                object:nil
                                                              userInfo:values];
        } else if([[CBUUID UUIDWithString:uuidHumedadService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"HUMEDAD [%@]",str);
#endif
            float rHVal = [sensorSHT21 calcPress:characteristic.value];
            NSDictionary *values = @{@"rHVal":[NSNumber numberWithFloat:rHVal]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationHumidityValueUpdated
                                                                object:nil
                                                              userInfo:values];
        } else if ([[CBUUID UUIDWithString:uuidButtonsService]isEqual:characteristic.service.UUID]){
#ifdef DEBUG
            NSLog(@"BUTTONS [%@]",str);
#endif
            int valor=[str intValue];
            
            NSDictionary *values = @{@"buttons":[NSNumber numberWithInt:valor]};
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationButtonsTapped
                                                                object:nil
                                                              userInfo:values];
        }
}




-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    peripheral.delegate = self;
    [peripheral discoverServices:nil];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"Error connectingPeripheral: %@", error);
}


-(void) peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    NSLog(@"Services scanned ![%@] ERR:%@",peripheral.name,error);
    for (CBService *s in peripheral.services) {
        [peripheral discoverCharacteristics:nil forService:s];
    }
}

-(void) peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSString *charact=CFBridgingRelease(CFUUIDCreateString(nil, (__bridge CFUUIDRef)(characteristic.UUID)));
    NSLog(@"UPDATE STATUS:%@ error = %@",charact,error.localizedDescription);
}

-(void) peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic %@ error = %@",characteristic,error);
}




@end

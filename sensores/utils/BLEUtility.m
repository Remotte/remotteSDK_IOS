/*
 *  bleUtility.m
 *
 * Created by Ole Andreas Torvmark on 10/2/12.
 * Copyright (c) 2012 Texas Instruments Incorporated - http://www.ti.com/
 * ALL RIGHTS RESERVED
 */

#import "BLEUtility.h"
#import <CoreBluetooth/CoreBluetooth.h>

@implementation BLEUtility

+(NSMutableDictionary *)makeSensorTagConfiguration:(NSString *)sensor {
        
         return [@{@"f000aa00-0451-4000-b000-000000000000": @"IR temperature service UUID",
                   @"f000aa01-0451-4000-b000-000000000000": @"IR temperature data UUID",
                   @"f000aa02-0451-4000-b000-000000000000": @"IR temperature config UUID",
                   @"f000aa03-0451-4000-b000-000000000000": @"IR temperature config UUID",
                   @"f000aa10-0451-4000-b000-000000000000": @"Accelerometer service UUID",
                   @"f000aa11-0451-4000-b000-000000000000": @"Accelerometer data UUID",
                   @"f000aa12-0451-4000-b000-000000000000": @"Accelerometer config UUID",
                   @"f000aa13-0451-4000-b000-000000000000": @"Accelerometer period UUID",
                   @"f000aa20-0451-4000-b000-000000000000": @"Humidity service UUID",
                   @"f000aa21-0451-4000-b000-000000000000": @"Humidity data UUID",
                   @"f000aa22-0451-4000-b000-000000000000": @"Humidity config UUID",
                   @"f000aa30-0451-4000-b000-000000000000": @"Magnetometer service UUID",
                   @"f000aa31-0451-4000-b000-000000000000": @"Magnetometer data UUID",
                   @"f000aa32-0451-4000-b000-000000000000": @"Magnetometer config UUID",
                   @"f000aa33-0451-4000-b000-000000000000": @"Magnetometer period UUID",
                   @"f000aa40-0451-4000-b000-000000000000": @"Barometer service UUID",
                   @"f000aa41-0451-4000-b000-000000000000": @"Barometer data UUID",
                   @"f000aa42-0451-4000-b000-000000000000": @"Barometer config UUID",
                   @"f000aa43-0451-4000-b000-000000000000": @"Barometer calibration UUID",
                   @"f000aa50-0451-4000-b000-000000000000": @"Gyroscope service UUID",
                   @"f000aa51-0451-4000-b000-000000000000": @"Gyroscope data UUID",
                   @"f000aa52-0451-4000-b000-000000000000": @"Gyroscope config UUID",
                   @"f000aa53-0451-4000-b000-000000000000": @"Gyroscope period UUID",
                   @"f000aa60-0451-4000-b000-000000000000": @"Update configuration service UUID",
                   @"f000aa61-0451-4000-b000-000000000000": @"Update configuration data UUID",
                   @"f000aa80-0451-4000-b000-000000000000": @"Motion Event service UUID",
                   @"f000aa81-0451-4000-b000-000000000000": @"Motion Event data UUID",
                   @"f000aa82-0451-4000-b000-000000000000": @"Motion Event config UUID",
                   @"0000ffe0-0000-1000-8000-00805f9b34fb": @"botones service",
                   @"0000ffe1-0000-1000-8000-00805f9b34fb": @"botones data"} mutableCopy];
}

+(NSString *)getKeyfor:(NSString *)key fromDic:(NSDictionary *)dictionary{
    NSArray *object=[dictionary allKeysForObject:key];
    NSString *sss=[object firstObject];
    if (!sss)
        sss=@"00000000-0000-0000-0000-000000000000";
    return sss;
}


+(void)configureService:(CBService *)service config:(NSString *)dict{
    NSDictionary *d=[BLEUtility makeSensorTagConfiguration:service.peripheral.name];
    
    NSString *uuidAcelService=[BLEUtility getKeyfor:@"Accelerometer service UUID" fromDic:d];//[d objectForKey:];
    NSString *uuidTemperatureService=[BLEUtility getKeyfor:@"IR temperature service UUID" fromDic:d];//[d objectForKey:@"IR temperature service UUID"];
    NSString *uuidGiroscopioService=[BLEUtility getKeyfor:@"Gyroscope service UUID" fromDic:d];//[d objectForKey:@"Gyroscope service UUID"];
    NSString *uuidBarometroService=[BLEUtility getKeyfor:@"Barometer service UUID" fromDic:d];//[d objectForKey:@"Barometer service UUID"];
    NSString *uuidMagnetometorService=[BLEUtility getKeyfor:@"Magnetometer service UUID" fromDic:d];//[d objectForKey:@"Magnetometer service UUID"];
    NSString *uuidHumedadService=[BLEUtility getKeyfor:@"Humidity service UUID" fromDic:d];//[d objectForKey:@"Humidity service UUID"];
    NSString *uuidUpdateConfig = [BLEUtility getKeyfor:@"Update configuration service UUID" fromDic:d];
    NSString *uuidMotionEvent = [BLEUtility getKeyfor:@"Motion Event service UUID" fromDic:d];
    NSString *botones=[BLEUtility getKeyfor:@"botones service" fromDic:d];//[d objectForKey:@"Humidity service UUID"];
    
    
    if (service.UUID){
    
    if ([[CBUUID UUIDWithString:uuidAcelService]isEqual:service.UUID]){
        NSLog(@"ACELEROMETRO");
        [BLEUtility configureAcelerometer:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidTemperatureService]isEqual:service.UUID]){
        NSLog(@"TEMPERATURA");
        [BLEUtility configureTemperature:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidGiroscopioService]isEqual:service.UUID]){
        NSLog(@"GIROSCOPIO");
        [BLEUtility configureGiroscopio:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidBarometroService]isEqual:service.UUID]){
        NSLog(@"BAROMETRO");
        [BLEUtility configureBarometro:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidMagnetometorService]isEqual:service.UUID]){
        NSLog(@"MAGNETOMETRO");
        [BLEUtility configureMagnetometro:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidHumedadService]isEqual:service.UUID]){
        NSLog(@"HUMEDAD");
        [BLEUtility configureHumedad:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidUpdateConfig]isEqual:service.UUID]){
        NSLog(@"UPDATE_CONFIGURATION");
        [BLEUtility configureUpdateConfiguration:service withConfig:d];
    }else if([[CBUUID UUIDWithString:uuidMotionEvent]isEqual:service.UUID]){
        NSLog(@"MOTION_EVENT");
        [BLEUtility configureMotionEvent:service withConfig:d];
    }else if([[CBUUID UUIDWithString:botones]isEqual:service.UUID]){
        NSLog(@"BOTONES");
         NSLog(@"----BOTONES? [%@]",CFUUIDCreateString(nil, (__bridge CFUUIDRef)(service.UUID)));
        [self configureDefault:service withConfig:d];
    }
    else{
        NSLog(@"----NO LO ES [%@][%@]",botones,CFUUIDCreateString(nil, (__bridge CFUUIDRef)(service.UUID)));
      //  [BLEUtility configureAcelerometer:service withConfig:d];

      //  [self configureDefault:service withConfig:d];
   //     [self configureDefault:service withConfig:d];

 
    }
    }
}
+(void)configureDefault:(CBService *)service withConfig:(NSDictionary *)d{
    NSString *botonSensor= [BLEUtility getKeyfor:@"botones data" fromDic:d]; //  [d objectForKey:@"Humidity data UUID"];
    for (CBCharacteristic *charac in service.characteristics){
        if ([[CBUUID UUIDWithString:botonSensor]isEqual:charac.UUID]){
            NSLog(@"__ CONFIG::Servicio:%@,  %@",[self CBUUIDToString:service.UUID],[self CBUUIDToString:charac.UUID]);

            [service.peripheral setNotifyValue:YES forCharacteristic:charac];
        }else{
            NSLog(@"NO CONFIG::Servicio:%@,  %@",[self CBUUIDToString:service.UUID],[self CBUUIDToString:charac.UUID]);

        }
    }
}

+(void)configureHumedad:(CBService *)servicioTemp withConfig:(NSDictionary *)d{
    NSString *uuidHumidityData= [BLEUtility getKeyfor:@"Humidity data UUID" fromDic:d]; //  [d objectForKey:@"Humidity data UUID"];
    NSString *uuidHumidityConfig  =[BLEUtility getKeyfor:@"Humidity config UUID" fromDic:d];//[d objectForKey:@"Humidity config UUID"];
    for (CBCharacteristic *charac in servicioTemp.characteristics){
        if ([[CBUUID UUIDWithString:uuidHumidityData]isEqual:charac.UUID]){
            //DATA
            [servicioTemp.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidHumidityConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioTemp.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }


}

+(void)configureMagnetometro:(CBService *)servicioAcel withConfig:(NSDictionary *)d{
    NSString *uuidAcelData=[BLEUtility getKeyfor:@"Magnetometer data UUID" fromDic:d];//[d objectForKey:@"Magnetometer data UUID"];
    NSString *uuidAcelConfig=[BLEUtility getKeyfor:@"Magnetometer config UUID" fromDic:d];//[d objectForKey:@"Magnetometer config UUID"];
    NSString *uuidAcelPeriod=[BLEUtility getKeyfor:@"Magnetometer period UUID" fromDic:d];//[d objectForKey:@"Magnetometer period UUID"];
    for (CBCharacteristic *charac in servicioAcel.characteristics){
        if ([[CBUUID UUIDWithString:uuidAcelData]isEqual:charac.UUID]){
            [servicioAcel.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidAcelConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioAcel.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
        if ([[CBUUID UUIDWithString:uuidAcelPeriod]isEqual:charac.UUID]){
            uint8_t periodData = (uint8_t)(200 / 10);
            NSData *data=[NSData dataWithBytes:&periodData length:1];
            [servicioAcel.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }
}

+(void)configureBarometro:(CBService *)servicioTemp withConfig:(NSDictionary *)d{
    //  NSString *uuidTempServicio=[d objectForKey:@"IR temperature service UUID"];
    NSString *uuidBaroData=   [BLEUtility getKeyfor:@"Barometer data UUID" fromDic:d];// [d objectForKey:@"Barometer data UUID"];
    NSString *uuidBaroConfig  =[BLEUtility getKeyfor:@"Barometer config UUID" fromDic:d];//[d objectForKey:@"Barometer config UUID"];
    NSString *uuidBaroCalibration  =[BLEUtility getKeyfor:@"Barometer calibration UUID" fromDic:d];//[d objectForKey:@"Barometer calibration UUID"];

    for (CBCharacteristic *charac in servicioTemp.characteristics){
        if ([[CBUUID UUIDWithString:uuidBaroData]isEqual:charac.UUID]){
            //DATA
            [servicioTemp.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidBaroConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x02;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioTemp.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
        if ([[CBUUID UUIDWithString:uuidBaroCalibration]isEqual:charac.UUID]){
            [servicioTemp.peripheral readValueForCharacteristic:charac];
        }
    }
}

+(void)configureGiroscopio:(CBService *)servicioTemp withConfig:(NSDictionary *)d{
    //  NSString *uuidTempServicio=[d objectForKey:@"IR temperature service UUID"];
    NSString *uuidTempData=   [BLEUtility getKeyfor:@"Gyroscope data UUID" fromDic:d];// [d objectForKey:@"Gyroscope data UUID"];
    NSString *uuidTempConfig  =[BLEUtility getKeyfor:@"Gyroscope config UUID" fromDic:d];//[d objectForKey:@"Gyroscope config UUID"];
    for (CBCharacteristic *charac in servicioTemp.characteristics){
        if ([[CBUUID UUIDWithString:uuidTempData]isEqual:charac.UUID]){
            //DATA
            [servicioTemp.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidTempConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioTemp.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }
}

+(void)configureTemperature:(CBService *)servicioTemp withConfig:(NSDictionary *)d{
  //  NSString *uuidTempServicio=[d objectForKey:@"IR temperature service UUID"];
    NSString *uuidTempData=[BLEUtility getKeyfor:@"IR temperature data UUID" fromDic:d];//[d objectForKey:@"IR temperature data UUID"];
    NSString *uuidTempConfig  =[BLEUtility getKeyfor:@"IR temperature config UUID" fromDic:d];[d objectForKey:@"IR temperature config UUID"];
    
    for (CBCharacteristic *charac in servicioTemp.characteristics){
        if ([[CBUUID UUIDWithString:uuidTempData]isEqual:charac.UUID]){
            //DATA
            [servicioTemp.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidTempConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioTemp.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }
}

+(void)configureAcelerometer:(CBService *)servicioAcel withConfig:(NSDictionary *)d{
    NSString *uuidAcelData=[BLEUtility getKeyfor:@"Accelerometer data UUID" fromDic:d];//[d objectForKey:@"Accelerometer data UUID"];
    NSString *uuidAcelConfig=[BLEUtility getKeyfor:@"Accelerometer config UUID" fromDic:d];//[d objectForKey:@"Accelerometer config UUID"];
    NSString *uuidAcelPeriod=[BLEUtility getKeyfor:@"Accelerometer period UUID" fromDic:d];//[d objectForKey:@"Accelerometer period UUID"];
    for (CBCharacteristic *charac in servicioAcel.characteristics){
        NSLog(@"PERIFERICO %@ ",CFUUIDCreateString(nil, (__bridge CFUUIDRef)(charac.UUID)));

        if ([[CBUUID UUIDWithString:uuidAcelData]isEqual:charac.UUID]){
            [servicioAcel.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidAcelConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioAcel.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
        if ([[CBUUID UUIDWithString:uuidAcelPeriod]isEqual:charac.UUID]){
            uint8_t periodData = (uint8_t)(150 / 10);
            NSData *data=[NSData dataWithBytes:&periodData length:1];
            [servicioAcel.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }
}


+(void)configureMotionEvent:(CBService *)servicioMotion withConfig:(NSDictionary *)d{
    NSString *uuidMotionData=[BLEUtility getKeyfor:@"Motion Event data UUID" fromDic:d];
    NSString *uuidMotionConfig=[BLEUtility getKeyfor:@"Motion Event config UUID" fromDic:d];

    for (CBCharacteristic *charac in servicioMotion.characteristics){

        if ([[CBUUID UUIDWithString:uuidMotionData]isEqual:charac.UUID]){
            [servicioMotion.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
        if ([[CBUUID UUIDWithString:uuidMotionConfig]isEqual:charac.UUID]){
            uint8_t b_data = 0x01;
            NSData *data=[NSData dataWithBytes:&b_data length:1];
            [servicioMotion.peripheral writeValue:data forCharacteristic:charac type:CBCharacteristicWriteWithResponse];
        }
    }
}


+(void)configureUpdateConfiguration:(CBService *)serviceConfig withConfig:(NSDictionary *)d{
    
    NSString *uuidConfigData=[BLEUtility getKeyfor:@"Update configuration data UUID" fromDic:d];
    
    for (CBCharacteristic *charac in serviceConfig.characteristics){
        
        if ([[CBUUID UUIDWithString:uuidConfigData]isEqual:charac.UUID]){
            [serviceConfig.peripheral setNotifyValue:YES forCharacteristic:charac];
        }
    }
}


+(void)writeCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}

+(void)writeCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID data:(NSData *)data {
    // Sends data to BLE peripheral to process HID and send EHIF command to PC
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID]) {
                    /* EVERYTHING IS FOUND, WRITE characteristic ! */
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
            }
        }
    }
}


+(void)readCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)readCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if([service.UUID isEqual:sCBUUID]) {
            for ( CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID]) {
                    /* Everything is found, read characteristic ! */
                    [peripheral readValueForCharacteristic:characteristic];
                }
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sUUID:(NSString *)sUUID cUUID:(NSString *)cUUID enable:(BOOL)enable {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:[CBUUID UUIDWithString:sUUID]]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:cUUID]])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}

+(void)setNotificationForCharacteristic:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *)cCBUUID enable:(BOOL)enable {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    /* Everything is found, set notification ! */
                    [peripheral setNotifyValue:enable forCharacteristic:characteristic];
                    
                }
                
            }
        }
    }
}


+(bool) isCharacteristicNotifiable:(CBPeripheral *)peripheral sCBUUID:(CBUUID *)sCBUUID cCBUUID:(CBUUID *) cCBUUID {
    for ( CBService *service in peripheral.services ) {
        if ([service.UUID isEqual:sCBUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics ) {
                if ([characteristic.UUID isEqual:cCBUUID])
                {
                    if (characteristic.properties & CBCharacteristicPropertyNotify) return YES;
                    else return NO;
                }
                
            }
        }
    }
    return NO;
}


+(CBUUID *) expandToTIUUID:(CBUUID *)sourceUUID {
    CBUUID *expandedUUID = [CBUUID UUIDWithString:TI_BASE_LONG_UUID];
    unsigned char expandedUUIDBytes[16];
    unsigned char sourceUUIDBytes[2];
    [expandedUUID.data getBytes:expandedUUIDBytes];
    [sourceUUID.data getBytes:sourceUUIDBytes];
    expandedUUIDBytes[2] = sourceUUIDBytes[0];
    expandedUUIDBytes[3] = sourceUUIDBytes[1];
    expandedUUID = [CBUUID UUIDWithData:[NSData dataWithBytes:expandedUUIDBytes length:16]];
    return expandedUUID;
}


+(NSString *) CBUUIDToString:(CBUUID *)inUUID {
  //  inUUID =[BLEUtility expandToTIUUID:inUUID];
    unsigned char i[16];
    [inUUID.data getBytes:i];
    if (inUUID.data.length == 2) {
        return [NSString stringWithFormat:@"%02hhx%02hhx",i[0],i[1]];
    }
    else {
        uint32_t g1 = ((i[0] << 24) | (i[1] << 16) | (i[2] << 8) | i[3]);
        uint16_t g2 = ((i[4] << 8) | (i[5]));
        uint16_t g3 = ((i[6] << 8) | (i[7]));
        uint16_t g4 = ((i[8] << 8) | (i[9]));
        uint16_t g5 = ((i[10] << 8) | (i[11]));
        uint32_t g6 = ((i[12] << 24) | (i[13] << 16) | (i[14] << 8) | i[15]);
        return [NSString stringWithFormat:@"%08x-%04hx-%04hx-%04hx-%04hx%08x",g1,g2,g3,g4,g5,g6];
    }
    return nil;
}


+(NSString*)hexRepresentationWithSpaces_AS:(NSData *)data space:(BOOL)spaces
{
    const unsigned char* bytes = (const unsigned char*)[data bytes];
    NSUInteger nbBytes = [data length];
    //If spaces is true, insert a space every this many input bytes (twice this many output characters).
    static const NSUInteger spaceEveryThisManyBytes = 4UL;
    //If spaces is true, insert a line-break instead of a space every this many spaces.
    static const NSUInteger lineBreakEveryThisManySpaces = 4UL;
    const NSUInteger lineBreakEveryThisManyBytes = spaceEveryThisManyBytes * lineBreakEveryThisManySpaces;
    NSUInteger strLen = 2*nbBytes + (spaces ? nbBytes/spaceEveryThisManyBytes : 0);
    
    NSMutableString* hex = [[NSMutableString alloc] initWithCapacity:strLen];
    for(NSUInteger i=0; i<nbBytes; ) {
        [hex appendFormat:@"%02X", bytes[i]];
        //We need to increment here so that the every-n-bytes computations are right.
        ++i;
        
        if (spaces) {
            if (i % lineBreakEveryThisManyBytes == 0) [hex appendString:@"\n"];
            else if (i % spaceEveryThisManyBytes == 0) [hex appendString:@" "];
        }
    }
    return hex;
}
  
@end

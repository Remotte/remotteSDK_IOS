//
//  SensorViewController.m
//  sensores
//
//  Created by jose garcia orozco on 12/11/13.
//  Copyright (c) 2013 jose garcia. All rights reserved.
//

#import "SensorViewController.h"
#define degrees(x) (180 * x / M_PI)
@interface SensorViewController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation SensorViewController
@synthesize attitude;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remotte_header"]];
    
    motionManager=[[CMMotionManager alloc] init];
    CMDeviceMotion *deviceMotion = motionManager.deviceMotion;
    attitude = deviceMotion.attitude;
    
    queue=[[NSOperationQueue alloc] init];
   /* [motionManager startAccelerometerUpdatesToQueue:queue withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
        [self updateAcellData:accelerometerData];
    }];*/
    [motionManager startGyroUpdatesToQueue:queue withHandler:^(CMGyroData *gyroData, NSError *error) {
        [self updateGyroData:gyroData];
    }];
    [motionManager startMagnetometerUpdatesToQueue:queue withHandler:^(CMMagnetometerData *magnetometerData, NSError *error) {
        [self updateMagnetoData:magnetometerData];
    }];
    [motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error) {
        if (attitude){
            [motion.attitude multiplyByInverseOfAttitude:attitude];
        }
        [self updateMotionData:motion];
    }];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(320, 568);
}
-(void)updateMotionData:(CMDeviceMotion *)acc{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [self.motx setProgress:(acc.rotationRate.x+1.0)/2];
        [self.moty setProgress:(acc.rotationRate.y+1.0)/2];
        [self.motz setProgress:(acc.rotationRate.z+1.0)/2];
        [self.motx1 setProgress:(acc.userAcceleration.x+1.0)/2];
        [self.moty1 setProgress:(acc.userAcceleration.y+1.0)/2];
        [self.motz1 setProgress:(acc.userAcceleration.z+1.0)/2];
  //      NSLog(@"-->%@",acc.attitude);
        [self.motx2 setProgress:(degrees(acc.attitude.pitch)+90.0)/180.0];
        [self.moty2 setProgress:(degrees(acc.attitude.roll)+180.0)/360.0];
        [self.motz2 setProgress:(degrees(acc.attitude.yaw)+180.0)/360.0];
        
    }];
}
-(void)updateMagnetoData:(CMMagnetometerData *)acc{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [self.magnetx setProgress:(acc.magneticField.x+1.0)/2];
        [self.magnety setProgress:(acc.magneticField.y+1.0)/2];
        [self.magnetz setProgress:(acc.magneticField.z+1.0)/2];
        
    }];
}

-(void)updateAcellData:(CMAccelerometerData *)acc{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [self.progressX setProgress:(acc.acceleration.x+1.0)/2];
        [self.progressY setProgress:(acc.acceleration.y+1.0)/2];
        [self.progressZ setProgress:(acc.acceleration.z+1.0)/2];
        
    }];
}

-(void)updateGyroData:(CMGyroData *)acc{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        [self.girox setProgress:(acc.rotationRate.x+1.0)/2];
        [self.giroy setProgress:(acc.rotationRate.y+1.0)/2];
        [self.giroz setProgress:(acc.rotationRate.z+1.0)/2];
        
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    [motionManager stopAccelerometerUpdates];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

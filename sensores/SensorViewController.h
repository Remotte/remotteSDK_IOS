//
//  SensorViewController.h
//  sensores
//
//  Created by jose garcia orozco on 12/11/13.
//  Copyright (c) 2013 jose garcia. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface SensorViewController : UIViewController 
{
    CMMotionManager *motionManager;
    NSOperationQueue *queue;
}
@property (nonatomic,retain)CMAttitude *attitude;
@property (weak, nonatomic) IBOutlet UIProgressView *progressX;
@property (weak, nonatomic) IBOutlet UIProgressView *progressY;
@property (weak, nonatomic) IBOutlet UIProgressView *progressZ;
@property (weak, nonatomic) IBOutlet UIProgressView *girox;
@property (weak, nonatomic) IBOutlet UIProgressView *giroy;
@property (weak, nonatomic) IBOutlet UIProgressView *giroz;
@property (weak, nonatomic) IBOutlet UIProgressView *magnetx;
@property (weak, nonatomic) IBOutlet UIProgressView *magnety;
@property (weak, nonatomic) IBOutlet UIProgressView *magnetz;
@property (weak, nonatomic) IBOutlet UIProgressView *motx;
@property (weak, nonatomic) IBOutlet UIProgressView *moty;
@property (weak, nonatomic) IBOutlet UIProgressView *motz;
@property (weak, nonatomic) IBOutlet UIProgressView *motx1;
@property (weak, nonatomic) IBOutlet UIProgressView *moty1;
@property (weak, nonatomic) IBOutlet UIProgressView *motz1;
@property (weak, nonatomic) IBOutlet UIProgressView *motx2;
@property (weak, nonatomic) IBOutlet UIProgressView *moty2;
@property (weak, nonatomic) IBOutlet UIProgressView *motz2;

@end

//
//  ConectarViewController.h
//  sensores
//
//  Created by jose garcia on 25/08/13.
//  Copyright (c) 2013 jose garcia. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RemotteDevice.h"


@interface ConectarViewController : UIViewController 


@property (assign)BOOL imagenMostrada;

@property (nonatomic, strong) RemotteDevice *remotte;
@property (nonatomic, strong) NSString *deviceName;




@end

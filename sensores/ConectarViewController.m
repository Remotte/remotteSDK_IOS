//
//  ConectarViewController.m
//  sensores
//
//  Created by jose garcia on 25/08/13.
//  Copyright (c) 2013 jose garcia. All rights reserved.
//

#import "ConectarViewController.h"



@interface ConectarViewController ()


@property (nonatomic,retain)NSDictionary *diccionarioConfig;

@property (weak, nonatomic) IBOutlet UILabel *nombreDispositivo;

@property (weak, nonatomic) IBOutlet UILabel *lblAcelerometro;
@property (weak, nonatomic) IBOutlet UILabel *lblGiroscopio;
@property (weak, nonatomic) IBOutlet UILabel *lblTemperatura;
@property (weak, nonatomic) IBOutlet UILabel *lblBotones;
@property (weak, nonatomic) IBOutlet UILabel *lblMagnetometro;
@property (weak, nonatomic) IBOutlet UILabel *lblBarometro;
@property (weak, nonatomic) IBOutlet UILabel *lblHumedad;

@property (weak, nonatomic) IBOutlet UIView *photoView;
@property (weak, nonatomic) IBOutlet UIImageView *imageResize;
@property (weak, nonatomic) IBOutlet UISwitch *switchFoto;
@property (weak, nonatomic) IBOutlet UISwitch *switchGiro;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation ConectarViewController


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
    
    _imagenMostrada=NO;
    [self.photoView setHidden:YES];
    
    [self.nombreDispositivo setText:self.deviceName];
    // Do any additional setup after loading the view from its nib.
}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateAcelerometerValue:) name:kNotificationAcelerometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateGyroscopeValue:) name:kNotificationGyroscopeValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTemperatureValue:) name:kNotificationTemperatureValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBarometerValue:) name:kNotificationBarometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMagnetometerValue:) name:kNotificationMagnetometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateHumidityValue:) name:kNotificationHumidityValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buttonsTapped:) name:kNotificationButtonsTapped object:nil];
    
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.scrollView.contentSize = CGSizeMake(320, 504);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationAcelerometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationGyroscopeValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationTemperatureValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationBarometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationMagnetometerValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationHumidityValueUpdated object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self  name:kNotificationButtonsTapped object:nil];
    
    [self.remotte disconnect];
    self.remotte = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickConectar:(id)sender {
    [self.remotte connect];
}

- (IBAction)clickImageView:(id)sender {
    self.imagenMostrada=YES;
    if (self.switchFoto.isOn){
        [self.imageResize setImage:[UIImage imageNamed:@"logo_negro.png"]];
    }else{
        [self.imageResize setImage:[UIImage imageNamed:@"glass_team_pano.png"]];
    }
    [self.photoView setHidden:NO];

}

- (IBAction)clickClose:(id)sender {
    self.imagenMostrada=NO;
    [self.photoView setHidden:YES];
    self.imageResize.transform = CGAffineTransformIdentity;
}

-(void)girarImagen:(float)x and_y:(float)y and_z:(float)z{
    
    if (self.imagenMostrada){
        float degrees = -(90.0*x);
        float zoom=(-z*0.5)+1;
        if(self.switchGiro.isOn){
            self.imageResize.transform = CGAffineTransformMakeRotation(degrees * M_PI/180);
        }else{
            self.imageResize.transform = CGAffineTransformMakeTranslation(degrees*4, 0);
        }
        self.imageResize.transform=CGAffineTransformScale(self.imageResize.transform, zoom, zoom);
    }
}


#pragma mark - Notifications Remotte Device

- (void)updateAcelerometerValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    float x= [values[@"x-axis"] floatValue];
    float y= [values[@"y-axis"] floatValue];
    float z= [values[@"z-axis"] floatValue];

    NSString *str=[NSString stringWithFormat:@"[% 0.1fG]X [% 0.1fG]Y [% 0.1fG]Z",x, y, z ];
    [self.lblAcelerometro setText:str];
    [self girarImagen:x and_y:y and_z:z];
}

- (void)updateGyroscopeValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    float x= [values[@"x-axis"] floatValue];
    float y= [values[@"y-axis"] floatValue];
    float z= [values[@"z-axis"] floatValue];
    
    NSString *str=[NSString stringWithFormat:@"[% 0.1f]X [% 0.1f]Y [% 0.1f]Z",x, y, z];
    [self.lblGiroscopio setText:str];
}

- (void)updateTemperatureValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    float tAmb = [values[@"tAmb"] floatValue];
    float tObj = [values[@"tObj"] floatValue];
    
    NSString *str=[NSString stringWithFormat:@"[%.1f°C]EXT [%.1f°C]INT",tAmb,tObj];
    [self.lblTemperatura setText:str];
}

- (void)updateBarometerValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    int pressure = [values[@"pressure"] intValue];
    [self.lblBarometro setText:[NSString stringWithFormat:@"PRES:[%d]",pressure]];
}

- (void)updateMagnetometerValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    float x= [values[@"x"] floatValue];
    float y= [values[@"y"] floatValue];
    float z= [values[@"z"] floatValue];
    
    NSString *str=[NSString stringWithFormat:@"[% 0.1f]X [% 0.1f]Y [% 0.1f]Z",x,y,z];
    [self.lblMagnetometro setText:str];
    
}

- (void)updateHumidityValue:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    float rHVal = [values[@"rHVal"] floatValue];
    [self.lblHumedad setText:[NSString stringWithFormat:@"%0.1f%%rH",rHVal]];

}

- (void)buttonsTapped:(NSNotification *)sender{
    
    NSDictionary *values = sender.userInfo;
    
    int valor=[values[@"buttons"] intValue];
    NSString *botonera=@"[  ] [  ]";
    switch (valor) {
        case 2:
            botonera=@"[X] [  ]";
            break;
        case 1:
            botonera=@"[  ] [X]";
            break;
        case 3:
            botonera=@"[X] [X]";
            break;
        default:
            break;
    }
    [self.lblBotones setText:botonera];
    
}

@end

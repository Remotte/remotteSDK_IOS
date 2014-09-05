//
//  ViewController.m
//  sensores
//
//  Created by jose garcia on 24/08/13.
//  Copyright (c) 2013 jose garcia. All rights reserved.
//

#import "ViewController.h"
#import "SensorViewController.h"
#import "ConectarViewController.h"

#import "RemotteDevice.h"

#import <CoreBluetooth/CoreBluetooth.h>

@interface ViewController () <UITableViewDataSource,UITableViewDelegate, CBCentralManagerDelegate,CBPeripheralDelegate>

@property (strong,nonatomic) CBCentralManager *manager;
@property (weak, nonatomic) IBOutlet UITableView *listadoDispositivos;

@end

@implementation ViewController{
    
    NSMutableArray *listaDispositivos;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    listaDispositivos=[[NSMutableArray alloc] init];
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"remotte_header"]];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return listaDispositivos.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%ld_Cell",(long)indexPath.row]];
  //  CBPeripheral *p = [self.sensorTags objectAtIndex:indexPath.row];
    CBPeripheral *p =listaDispositivos[indexPath.row];
    cell.textLabel.text = p.name;//[NSString stringWithFormat:@"%@",p.name];
    cell.detailTextLabel.text = [p.identifier UUIDString];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CBPeripheral *p =listaDispositivos[indexPath.row];
    
    if ([p.name isEqualToString:@"HID Remotte!"] ||
        [p.name isEqualToString:@"SensorTag"]) {
        
        RemotteDevice *device = [[RemotteDevice alloc] initWithManager:self.manager andPeripheral:p];
        
        ConectarViewController *conn=[[ConectarViewController alloc] initWithNibName:@"ConectarViewController" bundle:nil];
        conn.remotte = device;
        conn.deviceName = p.name;
        [self.navigationController pushViewController:conn animated:YES];
    }
}





- (IBAction)clickBTN:(id)sender {
    
    [listaDispositivos removeAllObjects];
    self.manager= [[CBCentralManager alloc]initWithDelegate:self queue:nil];
}



-(void)centralManagerDidUpdateState:(CBCentralManager *)central {
    if (central.state != CBCentralManagerStatePoweredOn) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"BLE not supported !" message:[NSString stringWithFormat:@"CoreBluetooth return state: %d",central.state] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
    else {
        [central scanForPeripheralsWithServices:nil options:nil];
    }
}

- (IBAction)clickSensores:(id)sender {
    SensorViewController *svc=[[SensorViewController alloc] initWithNibName:@"SensorViewController" bundle: nil];
    [self.navigationController pushViewController:svc animated:YES];
}



-(void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    NSLog(@"Found a BLE Device : %@",peripheral);
    
    /* iOS 6.0 bug workaround : connect to device before displaying UUID !
     The reason for this is that the CFUUID .UUID property of CBPeripheral
     here is null the first time an unkown (never connected before in any app)
     peripheral is connected. So therefore we connect to all peripherals we find.
     */
    
    peripheral.delegate = self;
    
    [listaDispositivos addObject:peripheral];
    [self.listadoDispositivos reloadData];
    
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral discoverServices:nil];
}


@end

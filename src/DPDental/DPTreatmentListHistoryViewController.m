//
//  DPTreatmentListHistoryViewController.m
//  DPDental
//
//  Created by Basil Mariano on 9/17/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTreatmentListHistoryViewController.h"
#import "DPTreatmentCell.h"
#import "DPTreatmentViewController.h"
#import "Treatment.h"

@interface DPTreatmentListHistoryViewController ()

@property (nonatomic, retain) NSMutableArray *treatments;

@end

@implementation DPTreatmentListHistoryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager sharedInstance]xibNameForDevice:@"DPTreatmentListHistoryViewController"];
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"History";
    }
    return self;
}

-(void) dealloc
{
    [_tableview release];
    [_treatments release];
    [super dealloc];
}

#pragma mark View Life Cycle

- (void) viewWillAppear:(BOOL)animated
{
    if (!self.treatments) {
        self.treatments = [[[NSMutableArray alloc] initWithArray:[Treatment treatmentsBeforeDate:[NSDate date]]] autorelease];
    } else {
        NSArray *treatmentList = [Treatment treatmentsBeforeDate:[NSDate date]];
        [self.treatments removeAllObjects];
        for (Treatment *treatment in treatmentList) {
            [self.treatments addObject:treatment];
        }
    }
    
    [_tableview reloadData];
}

- (void)viewDidLoad
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.treatments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DPTreatmentCell";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellIdentifier = @"DPTreatmentCell~ipad";
    }
    
    DPTreatmentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    if (self.treatments.count == 0) {
        return cell;
    }
    
    Treatment *treatment = (Treatment *) [self.treatments objectAtIndex:indexPath.row];
    
    NSDate *dateSched = [NSDate dateWithTimeIntervalSince1970:[treatment.dateInSecs doubleValue]];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    dateFormatter.dateFormat = @"dd/MM/yy";
    
    NSString *strDate = [dateFormatter stringFromDate:dateSched];
    
    cell.treatmentName.text = treatment.name;
    cell.doctorName.text = treatment.doctor;
    cell.date.text = strDate;
    
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Treatment *treatmentToDelete = (Treatment *) [self.treatments objectAtIndex:indexPath.row];
    
    [self.treatments removeObject:treatmentToDelete];
    [[[PCModelManager sharedManager] managedObjectContext] deleteObject:treatmentToDelete];
    [[PCModelManager sharedManager] saveContext];
    
    [tableView reloadData];
    
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 90.0f;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowHeight *= 2;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected index %ld", (long)indexPath.row);
    Treatment *treatment = (Treatment *) [self.treatments objectAtIndex:indexPath.row];
    
    DPTreatmentViewController *treatmentViewController = [[[DPTreatmentViewController alloc] initWithTreatmentHistory:treatment] autorelease];
    
    [self.navigationController pushViewController:treatmentViewController animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change the BG of the selected cell
    NSString *imageName = @"PICClinicModel.bundle/iphone_DP-Dental_ListView1_640x90.jpg";
    if (indexPath.row % 2 == 0) {
        imageName = @"PICClinicModel.bundle/iphone_DP-Dental_ListView2_640x90.jpg";
    }
    UIImageView *celBG = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
    cell.backgroundView = celBG;
}

@end

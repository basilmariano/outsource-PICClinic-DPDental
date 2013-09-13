//
//  DPTreatmentListViewController.m
//  DPDental
//
//  Created by Basil Mariano on 9/11/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTreatmentListViewController.h"
#import "DPTreatmentCell.h"
#import "DPTreatmentViewController.h"
#import "Treatment.h"

@interface DPTreatmentListViewController ()

@property (nonatomic, retain) NSMutableArray *treatments;

- (void) onAddClick;

@end

@implementation DPTreatmentListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager sharedInstance]xibNameForDevice:@"DPTreatmentListViewController"];
    
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Treatment";
    }
    
    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
   
    [addButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Add_btn_s.png" ] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Add_btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [addButton addTarget:self action:@selector(onAddClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[[UIView alloc] initWithFrame:addButton.frame] autorelease];
    [rightButtonView addSubview:addButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [addButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [addButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Add_btn_s.png" ] forState:UIControlStateNormal];
        [addButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Add_btn_ss.png" ] forState:UIControlStateHighlighted];
        
        rightButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    UIBarButtonItem *addButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:rightButtonView] autorelease];
    
    self.navigationItem.rightBarButtonItem = addButtonItem;
    
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
        self.treatments = [[[NSMutableArray alloc] initWithArray:[Treatment treatments]] autorelease];
    } else {
        NSArray *treatmentList = [Treatment treatments];
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
    
    DPTreatmentViewController *treatmentViewController = [[[DPTreatmentViewController alloc] initWithNibName:@"DPTreatmentListViewController" bundle:nil] autorelease];
    treatmentViewController.treatment = treatment;
    
    [self.navigationController pushViewController:treatmentViewController animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  indexPath;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //change the BG of the selected cell
}

#pragma mark Private Functions

- (void) onAddClick
{
    NSLog(@"Add");
    DPTreatmentViewController *newTreatment = [[[DPTreatmentViewController alloc] initWithNibName:@"DPTreatmentViewController" bundle:nil] autorelease];
    [self.navigationController pushViewController:newTreatment animated:YES];
}

@end

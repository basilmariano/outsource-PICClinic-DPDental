//
//  DPTreatmentViewController.m
//  DPDental
//
//  Created by Wong Johnson on 9/11/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPTreatmentViewController.h"
#import "ManageObjectModel.h"
#import "FPPopoverController.h"

typedef enum
{
    DatePicker,
    TimePicker,
    ListPicker
    
} PickerType;

@interface DPTreatmentViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIPopoverControllerDelegate, UIActionSheetDelegate>

@property (nonatomic) PickerType pickerType;
@property (nonatomic, retain) UIActionSheet *actionSheet;
@property (nonatomic, retain) UIDatePicker *datePicker;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) UIPopoverController *popOver;
@property (nonatomic, retain) NSArray *doctorList;
@property (nonatomic, retain) NSArray *treatmentList;
@property (nonatomic, retain) NSArray *pickerData;
@property (nonatomic, retain) UIView *selectedView;
@property (nonatomic, retain) NSDate *dateSelected;
@property (nonatomic, retain) NSDate *timeSelected;
@property (nonatomic, retain) IBOutlet UITextField *doctorName;
@property (nonatomic, retain) IBOutlet UITextField *treatmentName;
@property (nonatomic, retain) IBOutlet UITextField *stepsDate;
@property (nonatomic, retain) IBOutlet UITextField *stepsTime;
@property (nonatomic, retain) IBOutlet UITextField *journalName;
@property (nonatomic, retain) IBOutlet UIButton *buttonDoctors;
@property (nonatomic, retain) IBOutlet UIButton *buttonTreatments;
@property (nonatomic, retain) IBOutlet UIButton *buttonDates;
@property (nonatomic, retain) IBOutlet UIButton *buttonTime;
@property (nonatomic, retain) IBOutlet UIView *viewJournal;
@property (nonatomic, retain) UIButton *rightButton;
@property (nonatomic, retain) NSString *assignedjournalName;
@property (nonatomic, retain) NSString *assignedjournalArticleId;

- (IBAction)onButtonDoctorsClick:(id)sender;
- (IBAction)onButtonTreatmentClick:(id)sender;
- (IBAction)onButtonDatesClick:(id)sender;
- (IBAction)onButtonTimeClick:(id)sender;

@end

@implementation DPTreatmentViewController
{
    bool isEditing;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager sharedInstance] xibNameForDevice:@"DPTreatmentViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {

        [[PCRequestHandler sharedInstance] requestGroupList:@"35"];
        [[PCRequestHandler sharedInstance] requestGroupList:@"38"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(treatmentListData:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",@"35"]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doctorListData:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",@"38"]
                                                   object:nil];
    }
    
    self.navigationItem.title = @"New Treatment";
    self.navigationItem.leftBarButtonItem = [self leftBatButton];
    self.navigationItem.rightBarButtonItem = [self rightBatButton];
    
    return self;
}

- (id)initWithTreatment: (Treatment *) treatement
{
    NSString *nibName = [[XCDeviceManager sharedInstance] xibNameForDevice:@"DPTreatmentViewController"];
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        
        [[PCRequestHandler sharedInstance] requestGroupList:@"35"];
        [[PCRequestHandler sharedInstance] requestGroupList:@"38"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(treatmentListData:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",@"35"]
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(doctorListData:)
                                                     name:[NSString stringWithFormat:DATA_KEY,@"list",@"38"]
                                                   object:nil];
    }
    
    self.treatment = treatement;
    
    self.navigationItem.title = treatement.name;
    self.navigationItem.leftBarButtonItem = [self leftBatButton];
    self.navigationItem.rightBarButtonItem = [self rightBarButtonExtras];
    
    return self;
}

- (void) dealloc
{
    [_treatment release];
    [_actionSheet release];
    [_datePicker release];
    [_pickerView release];
    [_popOver release];
    [_doctorList release];
    [_treatmentList release];
    [_pickerData release];
    [_selectedView release];
    [_dateSelected release];
    [_timeSelected release];
    [_doctorName release];
    [_treatmentName release];
    [_stepsDate release];
    [_stepsTime release];
    [_journalName release];
    [_buttonDoctors release];
    [_buttonTreatments release];
    [_buttonDates release];
    [_buttonTime release];
    [_rightButton release];
    [_viewJournal release];
    [_assignedjournalName release];
    [_assignedjournalArticleId release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}
#pragma mark View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.treatment) {
        
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:[self.treatment.dateInSecs doubleValue]];
        
        NSDateFormatter *formatDate = [[[NSDateFormatter alloc] init] autorelease];
        [formatDate setTimeZone:_datePicker.timeZone];
        [formatDate setDateFormat:@"dd/MM/yy"];
        
        NSDateFormatter *formatTime = [[[NSDateFormatter alloc] init] autorelease];
        [formatTime setTimeZone:[NSTimeZone defaultTimeZone]];
        [formatTime setDateFormat:@"hh:mm aa"];
        
          
        NSString *strDate = [formatDate stringFromDate:date];
        NSString *strTime = [formatTime stringFromDate:date];
        
        self.treatmentName.text = self.treatment.name;
        self.doctorName.text = self.treatment.doctor;
        self.stepsDate.text = strDate;
        self.stepsTime.text = strTime;
        self.journalName.text = self.treatment.journalName;
        
        [_buttonTime setUserInteractionEnabled:NO];
        [_buttonTreatments setUserInteractionEnabled:NO];
        [_buttonDates setUserInteractionEnabled:NO];
        [_buttonDoctors setUserInteractionEnabled:NO];
        
        [_viewJournal setHidden:NO];
        
    }
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    int rows = self.pickerData.count;
    return rows;
}

#pragma mark UIPickerViewDelegate
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *rowTittle = [[self.pickerData objectAtIndex:row] objectForKey:@"item_name"];
    return rowTittle;
}

#pragma mark UIActionSheet
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSString *buttonNormalImageName = @"PICClinicModel.bundle/iphone_Done_btn_s.png";
        NSString *buttonHighlightedImageName = @"PICClinicModel.bundle/iphone_Done_btn_sa.png";
        
        if ([XCDeviceManager sharedInstance].deviceType == iPad_Device) {
            buttonNormalImageName = @"PICClinicModel.bundle/ipad_Done_btn_s.png";
            buttonHighlightedImageName = @"PICClinicModel.bundle/ipad_Done_btn_sa.png";
        }
        
        [_rightButton setImage:[UIImage imageNamed: buttonNormalImageName] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed: buttonHighlightedImageName ] forState:UIControlStateHighlighted];
        
        [_buttonDoctors setUserInteractionEnabled:YES];
        [_buttonDates setUserInteractionEnabled:YES];
        
        isEditing = YES;
    } else if (buttonIndex == 1) {
        PCModelWebViewController * webViewController = [[[PCModelWebViewController alloc] initWithTreatment:self.treatment] autorelease];
        
        [self.navigationController pushViewController:webViewController animated:YES];
        
    } else {
        NSLog(@"Cancel");
    }
}

#pragma mark Selectors
- (void) treatmentListData:(NSNotification *)notification
{
    NSLog(@"treatmentList: %@", [notification userInfo]);
    if (self.treatmentList == nil) {
        self.treatmentList = [[[NSArray alloc] init] autorelease];
    }
    
    self.treatmentList = [[[notification userInfo] objectForKey:@"list"] objectForKey:@"items"];
   // NSLog(@"treatmentList: %@", self.treatmentList);
}

- (void) doctorListData:(NSNotification *)notification
{
    //NSLog(@"doctorList: %@", [notification userInfo]);
    if (self.doctorList == nil) {
        self.doctorList = [[[NSArray alloc] init] autorelease];
    }
    
    self.doctorList = [[[notification userInfo] objectForKey:@"list"] objectForKey:@"items"];
    //NSLog(@"doctorList: %@", self.doctorList);
}

- (void) onBackClick
{
    [[ManageObjectModel objectManager] rollback];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) onExtrasClick: (id) sender
{
    if (isEditing) {
        NSString *buttonNormalImageName = @"PICClinicModel.bundle/iphone_Extra_btn_s.png";
        NSString *buttonHighlightedImageName = @"PICClinicModel.bundle/iphone_Extra_btn_sa.png";
        
        if ([XCDeviceManager sharedInstance].deviceType == iPad_Device) {
            buttonNormalImageName = @"PICClinicModel.bundle/ipad_Extra_btn_s.png";
            buttonHighlightedImageName = @"PICClinicModel.bundle/ipad_Extra_btn_sa.png";
        }
        
        [_rightButton setImage:[UIImage imageNamed: buttonNormalImageName] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed: buttonHighlightedImageName ] forState:UIControlStateHighlighted];
        
        [self saveTreatment];
        
        isEditing = NO;
    } else {
        UIActionSheet *extrasActionSheet = [[[UIActionSheet alloc] initWithTitle:@"Extras" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
        [extrasActionSheet buttonTitleAtIndex:[extrasActionSheet addButtonWithTitle:@"Edit"]];
        [extrasActionSheet buttonTitleAtIndex:[extrasActionSheet addButtonWithTitle:@"Journal"]];
        [extrasActionSheet buttonTitleAtIndex:[extrasActionSheet addButtonWithTitle:@"Cancel"]];
        [extrasActionSheet showFromTabBar: self.tabBarController.tabBar];

    }
}

- (void) onDoneClick: (id) sender
{
    [self saveTreatment];
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*- (void) debugPurposes
{
    NSDateFormatter *dateSched = [[[NSDateFormatter alloc] init] autorelease];
    dateSched.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateSched setDateFormat:@"dd/MM/yy"];
    ////=======> wiered!!!!
    
    NSDateFormatter *timeSched = [[[NSDateFormatter alloc] init] autorelease];
     dateSched.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
     [timeSched setDateFormat:@"hh:mm aa"];
    
    NSDate *selectedDate = [dateSched dateFromString:self.stepsDate.text];
    //NSDate *selectedTime = [timeSched dateFromString:self.stepsTime.text];
    
    NSTimeInterval schedTimeInterval = [selectedDate timeIntervalSince1970] + [self.timeSelected timeIntervalSince1970];
    
    NSDate *finalDate = [NSDate dateWithTimeIntervalSince1970:schedTimeInterval];
    
    
    NSDateFormatter *finalSched = [[[NSDateFormatter alloc] init] autorelease];
    finalSched.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [finalSched setDateFormat:@"dd/MM/yy hh:mm aa"];
    
    NSString *strDate = [finalSched stringFromDate:finalDate];
    NSString *strTime = [timeSched stringFromDate:finalDate];
    NSLog(@"Date Dinal: %@", strDate);
    NSLog(@"Time Dinal: %@", strTime);
    Class cls = NSClassFromString(@"UILocalNotification");
     
     UILocalNotification *notif = [[cls alloc] init];
     notif.fireDate = [NSDate dateWithTimeIntervalSince1970:schedTimeInterval];
     notif.timeZone = [NSTimeZone defaultTimeZone];
     
     
     notif.alertBody = @"Correct";
     notif.alertAction = @"Show me";
     notif.soundName = UILocalNotificationDefaultSoundName;
     notif.applicationIconBadgeNumber = 1;
     notif.repeatInterval = 0;
     
     
     [[UIApplication sharedApplication] scheduleLocalNotification:notif];
     
     [notif release];
    NSLog(@"THIS IS PERFECT! %@", notif.fireDate);
    NSLog(@"THIS IS PERFECT!");
    NSLog(@"Sil's got no Deja vu!!");

}*/

- (void)okTapped:(NSObject *)sender
{
    
    switch (self.pickerType) {
        case DatePicker: {
            
            self.dateSelected = self.datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"dd/MM/yyyy"];
            
            NSString *strDate = [dateFormat stringFromDate:self.dateSelected];
            self.stepsDate.text = strDate;
            
            [dateFormat release];
            
            break;
        } case TimePicker: {
            
            self.timeSelected = self.datePicker.date;
            
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setDateFormat:@"hh:mm aa"];
            
            NSString *strTime = [dateFormat stringFromDate:self.timeSelected];
            self.stepsTime.text = strTime;
            
            [dateFormat release];
            
            break;
        } case ListPicker: {
            
            int selectedRow = [_pickerView selectedRowInComponent:0];
            NSString *pickedData = [[self.pickerData objectAtIndex: selectedRow] objectForKey:@"item_name"];
            
            if (self.selectedView.tag == 0) { //treatment button
                NSString *journalName = [[self.pickerData objectAtIndex: selectedRow] objectForKey:@"item_desc"];
                NSString *articleId = [[self.pickerData objectAtIndex: selectedRow] objectForKey:@"action_id"];
                
                self.assignedjournalName = journalName;
                self.assignedjournalArticleId = articleId;
                self.treatmentName.text = pickedData;
            } else { //doctor button
                self.doctorName.text = pickedData;
            }
            
            break;
        }
    }
    
    [self dismissResponders];
}

- (void)cancelTapped:(NSObject *)sender
{
    [self dismissResponders];
}

#pragma mark IBOutlets
- (IBAction)onButtonDoctorsClick:(id)sender
{
    self.selectedView = (UIView *) sender;
    self.pickerData = self.doctorList;
    self.pickerType = ListPicker;
    
    UIButton *button = (UIButton *) sender;
    [self showPickerActionSheet:@"Doctor" andObjectView: button];
}

- (IBAction)onButtonTreatmentClick:(id)sender
{
    self.selectedView = (UIView *) sender;
    self.pickerData = self.treatmentList;
    self.pickerType = ListPicker;
    
    UIButton *button = (UIButton *) sender;
    [self showPickerActionSheet:@"Treatment" andObjectView: button];
}

- (IBAction)onButtonDatesClick:(id)sender
{
    self.pickerType = DatePicker;
    
    UIButton *button = (UIButton *) sender;
    [self showPickerActionSheet:@"Step Date" andObjectView: button];
}

- (IBAction)onButtonTimeClick:(id)sender
{
    self.pickerType = TimePicker;
    
    UIButton *button = (UIButton *) sender;
    [self showPickerActionSheet:@"Step Time" andObjectView: button];
}

#pragma mark Private Functions
- (UIPickerView *)listPickerForActionSheet
{
    CGRect listPickerFrame = CGRectMake(0.0f, 30.0f, 0.0f, 0.0f);
   
    if ([[XCDeviceManager sharedInstance] deviceType] == iPad_Device) {
        listPickerFrame = CGRectMake(10,25, 700, 220);
    }
    
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:listPickerFrame];
    pickerView.dataSource = self;
    pickerView.delegate = self;
    pickerView.showsSelectionIndicator = YES;
    return [pickerView autorelease];
    
    return  nil;
}

- (UIDatePicker *)datePickerForActionSheet
{
    CGRect datePickerFrame = CGRectMake(0.0f, 30.0f, 0.0f, 0.0f);
    
    if ([[XCDeviceManager sharedInstance] deviceType] == iPad_Device) {
        datePickerFrame = CGRectMake(10,25, 700, 220);
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    [datePicker setMinimumDate:[NSDate date]];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    
    return [datePicker autorelease];
    
}

- (UIDatePicker *)timePickerForActionSheet
{
    CGRect datePickerFrame = CGRectMake(0.0f, 30.0f, 0.0f, 0.0f);
    
    if ([[XCDeviceManager sharedInstance] deviceType] == iPad_Device) {
        datePickerFrame = CGRectMake(10,25, 700, 220);
    }
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:datePickerFrame];
    datePicker.datePickerMode = UIDatePickerModeTime;
    datePicker.timeZone = [NSTimeZone localTimeZone];
    datePicker.date = [NSDate dateWithTimeIntervalSince1970:0];
    
    return [datePicker autorelease];
    
}

- (void)showPickerActionSheet:(NSString *)title andObjectView:(UIView *)views
{
    
    CGRect btnOkRect;
    CGRect btnCancelRect;
    CGRect titleLabelRect;
    UIView *view = [[UIView alloc] init];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        UIViewController *contentViewController = [[[UIViewController alloc] init] autorelease];
        contentViewController.contentSizeForViewInPopover = CGSizeMake(760.0f, 300.0f);
        self.popOver = [[UIPopoverController alloc] initWithContentViewController:contentViewController];
        self.popOver.delegate = self;
        view = contentViewController.view;
        [_popOver presentPopoverFromRect:views.bounds inView:views permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
        titleLabelRect = CGRectMake(230.0f, -10, 278.0f, 40.0f);
        btnOkRect = CGRectMake(260.0f, 250.0f, 100.0f, 40.0f);
        btnCancelRect = CGRectMake(380.0f, 250.0f, 100.0f, 40.0f);
        
    } else  if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        
        UIActionSheet *actionSheet = [[UIActionSheet alloc] init];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
        
        view = actionSheet;
        
        titleLabelRect = CGRectMake(21.0f, -3, 278.0f, 40.0f);
        btnOkRect = CGRectMake(60.0f, 250.0f, 100.0f, 40.0f);
        btnCancelRect = CGRectMake(170.0f, 250.0f, 100.0f, 40.0f);
        
        [actionSheet showInView:self.view];
        actionSheet.frame = CGRectMake(0.0f, self.view.bounds.size.height - 300.0f, actionSheet.frame.size.width, 300.0f);
        self.actionSheet = actionSheet;
    }

    switch (self.pickerType) {
        case ListPicker: {
            self.pickerView = [self listPickerForActionSheet];
            [view addSubview:self.pickerView];
            break;
        }
        case DatePicker: {
            self.datePicker = [self datePickerForActionSheet];
            self.datePicker.date = [NSDate date];
            [view addSubview:self.datePicker];
            break;
        }
        case TimePicker: {
            self.datePicker = [self timePickerForActionSheet];
            [view addSubview:self.datePicker];
            break;
        }

    }
    
    UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(250.0f, 0, 278.0f, 45.0f)] autorelease] ;
    titleLabel.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.text = title;
    titleLabel.frame = titleLabelRect;
    
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    [okButton setTitle:@"Ok" forState:UIControlStateNormal];
    okButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    okButton.frame = btnOkRect;
    [okButton addTarget:self action:@selector(okTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"ButtonBg.png"] forState:UIControlStateNormal];
    [cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    cancelButton.frame = btnCancelRect;
    [cancelButton addTarget:self action:@selector(cancelTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:okButton];
    [view addSubview:cancelButton];
    [view addSubview:titleLabel];
    [view release];
}

- (void) dismissResponders
{
    if(_actionSheet) {
        [_actionSheet dismissWithClickedButtonIndex:0 animated:YES];
        self.actionSheet = nil;
    }
    
    if(_datePicker)
        self.datePicker = nil;
    if(_pickerView) {
        self.pickerView = nil;
    }
    
    if(_popOver) {
        [_popOver dismissPopoverAnimated:YES];
        self.popOver = nil;
    }
    
}

- (UIBarButtonItem *) leftBatButton
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
    
    [backButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Back_btn_s.png" ] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Back_btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(onBackClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *leftButtonView = [[[UIView alloc] initWithFrame:backButton.frame] autorelease];
    [leftButtonView addSubview:backButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [backButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [backButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Back_btn_s.png" ] forState:UIControlStateNormal];
        [backButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Back_btn_ss.png" ] forState:UIControlStateHighlighted];
        
        leftButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    return  [[[UIBarButtonItem alloc] initWithCustomView:leftButtonView] autorelease];
}

- (UIBarButtonItem *) rightBatButton
{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
    
    [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Done_btn_s.png" ] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Done_btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [_rightButton addTarget:self action:@selector(onDoneClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[[UIView alloc] initWithFrame:_rightButton.frame] autorelease];
    [rightButtonView addSubview:_rightButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [_rightButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Done_btn_s.png" ] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Done_btn_ss.png" ] forState:UIControlStateHighlighted];
        
        rightButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    return  [[[UIBarButtonItem alloc] initWithCustomView:rightButtonView] autorelease];
}

- (UIBarButtonItem *) rightBarButtonExtras
{
    self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
    
    [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Extra_btn_s.png" ] forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Extra_btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [_rightButton addTarget:self action:@selector(onExtrasClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[[UIView alloc] initWithFrame:_rightButton.frame] autorelease];
    [rightButtonView addSubview:_rightButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [_rightButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Extra_btn_s.png" ] forState:UIControlStateNormal];
        [_rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Extra_btn_ss.png" ] forState:UIControlStateHighlighted];
        
        rightButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    return  [[[UIBarButtonItem alloc] initWithCustomView:rightButtonView] autorelease];
}

- (void) saveTreatment
{
    NSDateFormatter *dateSched = [[[NSDateFormatter alloc] init] autorelease];
    dateSched.timeZone = [NSTimeZone defaultTimeZone];
    [dateSched setDateFormat:@"dd/MM/yy"];
    
    NSDateFormatter *timeSched = [[[NSDateFormatter alloc] init] autorelease];
    dateSched.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [timeSched setDateFormat:@"hh:mm aa"];
    
    
    NSDate *selectedDate = [dateSched dateFromString:self.stepsDate.text];
    
    NSTimeInterval schedTimeInterval = [selectedDate timeIntervalSince1970] + [self.timeSelected timeIntervalSince1970];
    
    NSNumber *dateSchedInSecs = [NSNumber numberWithDouble:schedTimeInterval];
    
    //check if the given value is NSNumber and convert to NSString object
    if ([self.assignedjournalArticleId isKindOfClass:[NSNumber class]]) {
        self.assignedjournalArticleId = [(NSNumber *) self.assignedjournalArticleId stringValue];
    }
    
    if (!self.treatment) {
        
        Treatment *treatment = [Treatment newTreatment];
        treatment.name = self.treatmentName.text;
        treatment.doctor = self.doctorName.text;
        treatment.dateInSecs = dateSchedInSecs;
        treatment.journalName = self.assignedjournalName;
        treatment.articleId = self.assignedjournalArticleId;
        
        [[PCModelManager sharedManager] saveContext];
        
    } else {
        
        self.treatment.name = self.treatmentName.text;
        self.treatment.doctor = self.doctorName.text;
        self.treatment.dateInSecs = dateSchedInSecs;
        self.treatment.journalName = self.assignedjournalName;
        self.treatment.articleId = self.assignedjournalArticleId;
        
        [[PCModelManager sharedManager] saveContext];
    }
    
}

@end

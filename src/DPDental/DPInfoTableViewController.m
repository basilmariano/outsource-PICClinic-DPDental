//
//  DPInfoTableViewController.m
//  DPDental
//
//  Created by Basil Mariano on 9/18/13.
//  Copyright (c) 2013 Panfilo Mariano. All rights reserved.
//

#import "DPInfoTableViewController.h"
#import "DPInfoCell.h"
#import "Journal.h"

@interface DPInfoTableViewController () <UIActionSheetDelegate>

@property (nonatomic, retain) NSMutableArray *journals;

@end

@implementation DPInfoTableViewController
{
    bool forJournal;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSString *nibName = [[XCDeviceManager sharedInstance] xibNameForDevice:@"DPInfoTableViewController"];
    self = [super initWithNibName:nibName bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    
    self.navigationItem.title = @"Info";
    
    self.navigationItem.rightBarButtonItem = [self rightBarButton];
    
    return self;
}

- (id)initWithJournals
{
    NSString *nibName = [[XCDeviceManager sharedInstance] xibNameForDevice:@"DPInfoTableViewController"];
    self = [super initWithNibName:nibName bundle:nil];
    if (self) {
        // Custom initialization
    }
    
    forJournal = YES;
    self.navigationItem.title = @"Journals";
    self.navigationItem.leftBarButtonItem = [self leftBarButton];
    
    return self;
}

- (void) dealloc
{
    [_journals release];
    [_tableView release];
    [super dealloc];
}

- (void) viewWillAppear:(BOOL)animated
{
    if (!self.journals) {
        self.journals = [[[NSMutableArray alloc] initWithArray:[Journal journals]] autorelease];
    } else {
        NSArray *journalList = [Journal journals];
        [self.journals removeAllObjects];
        for (Journal *journal in journalList) {
            [self.journals addObject:journal];
        }
    }
    
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = self.journals.count;
    if (!forJournal) {
        rows += 2;
    }
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DPInfoCell";
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        cellIdentifier = @"DPInfoCell~ipad";
    }
    
    DPInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:cellIdentifier owner:self options:nil] objectAtIndex:0];
    }
    
    int index = indexPath.row;
    
    if (!forJournal) {
        if (indexPath.row == 0) {
            cell.tittle.text = @"FAQ";
            return  cell;
        } else if (indexPath.row == 1) {
            cell.tittle.text = @"Emergency";
            return cell;
        }
        
        index -= 2;
    }
    
    if (self.journals.count == 0) {
        return cell;
    }
 
    Journal *journal = (Journal *) [self.journals objectAtIndex:index];
    
    cell.tittle.text = journal.name;
    
    return  cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!forJournal) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return UITableViewCellEditingStyleNone;
        }
    }
    
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    int index = indexPath.row;
    
    if(!forJournal) {
        if (indexPath.row == 0 || indexPath.row == 1) {
            return;
        }
        index -= 2;
    }
    
    Journal *journalToDelete = (Journal *) [self.journals objectAtIndex:index];
    
    [self.journals removeObject:journalToDelete];
    [[[PCModelManager sharedManager] managedObjectContext] deleteObject:journalToDelete];
    [[PCModelManager sharedManager] saveContext];
    
    [tableView reloadData];
    
}


#pragma mark UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    float rowHeight = 44.0f;
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        rowHeight *= 2;
    }
    return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"Selected index %ld", (long)indexPath.row);
    
    int index = indexPath.row;
    
    if (!forJournal) {
        if (indexPath.row == 0) {
            PCModelTableViewController *faqTableView = [[[PCModelTableViewController alloc] initWithGroupListId:@"39" andGroupListTitle:@"FAQ" andCompanyId:[PCRequestHandler sharedInstance].companyId andHidesBackButtonFirst:NO] autorelease];
            
            [self.navigationController pushViewController:faqTableView animated:YES];
            
            return;
            
        } else if (indexPath.row == 1) {
            PCModelTableViewController *faqTableView = [[[PCModelTableViewController alloc] initWithGroupListId:@"40" andGroupListTitle:@"Emergency" andCompanyId:[PCRequestHandler sharedInstance].companyId andHidesBackButtonFirst:NO] autorelease];
            
            [self.navigationController pushViewController:faqTableView animated:YES];
            
            return;
        }
        
        index -= 2;
    }
    
    Journal *journal = (Journal *) [self.journals objectAtIndex:index];
    
    PCModelWebViewController *journalArticle = [[[PCModelWebViewController alloc] initWithShareButtonAndArticleId:journal.article_id andArticleTitle:journal.name andCompanyId:[PCRequestHandler sharedInstance].companyId ]autorelease];
    
    [self.navigationController pushViewController:journalArticle animated:YES];
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

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        DPInfoTableViewController *journals = [[[DPInfoTableViewController alloc] initWithJournals] autorelease];
        [self.navigationController pushViewController:journals animated:YES];
    }
}

#pragma mark Selectors
- (void) onMoreClick: (id) sender
{
    UIActionSheet *actionSheet = [[[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil] autorelease];
    
    [actionSheet buttonTitleAtIndex:[actionSheet addButtonWithTitle:@"Read More"]];
    [actionSheet buttonTitleAtIndex:[actionSheet addButtonWithTitle:@"Cancel"]];
    
    [actionSheet showFromTabBar:self.tabBarController.tabBar];

}

- (void) onBackClick: (id) sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Private Functions
- (UIBarButtonItem *) rightBarButton
{
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
    
    [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_DP-Dental_More-btn_s.png" ] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_DP-Dental_More-btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(onMoreClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[[UIView alloc] initWithFrame:rightButton.frame] autorelease];
    [rightButtonView addSubview:rightButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [rightButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_DP-Dental_More-btn_s.png" ] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_DP-Dental_More-btn_ss.png" ] forState:UIControlStateHighlighted];
        
        rightButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    return  [[[UIBarButtonItem alloc] initWithCustomView:rightButtonView] autorelease];
    
}

- (UIBarButtonItem *) leftBarButton
{
    UIButton *rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0.0f, 0.0f, 45.5f, 28.0f)];
    
    [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Back_btn_s.png" ] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/iphone_Back_btn_ss.png" ] forState:UIControlStateHighlighted];
    
    [rightButton addTarget:self action:@selector(onBackClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *rightButtonView = [[[UIView alloc] initWithFrame:rightButton.frame] autorelease];
    [rightButtonView addSubview:rightButton];
    
    if ([XCDeviceManager sharedInstance].deviceType == iPad_Device ) {
        
        [rightButton setFrame:CGRectMake(0.0f, 17.0f, 105.5f, 66.5f)];
        [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Back_btn_s.png" ] forState:UIControlStateNormal];
        [rightButton setImage:[UIImage imageNamed:@"PICClinicModel.bundle/ipad_Back_btn_ss.png" ] forState:UIControlStateHighlighted];
        
        rightButtonView.frame = CGRectMake(0.0f, 0.0f, 105.5f, 66.5f);
    }
    
    return  [[[UIBarButtonItem alloc] initWithCustomView:rightButtonView] autorelease];
    
}

@end

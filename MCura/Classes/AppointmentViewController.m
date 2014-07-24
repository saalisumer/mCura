//
//  AppointmentViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "AppointmentViewController.h"
#import "Patdemographics.h"
#import "Utils.h"
#import "ISActivityOverlayController.h"
#import "_GMDocService.h"
#import "GetPatientContactDetail.h"
#import "DataExchange.h"
#import "Schedule.h"
#import "GetPatientInvocation.h"
#import "Patient.h"
#import "STPNLoggedIn.h"
#import "LabOrderViewController.h"
#import "PharmacyViewController.h"
#import "DataExchange.h"
#import "SubTenant.h"

@interface AppointmentViewController (private)<GetPatientInvocationnDelegate, LabOrderViewControllerDelegate, GetSubtenIdInvocationDelegate>
@end

@implementation AppointmentViewController

@synthesize pat, tblView, txtSearch, popoverController,phone;
@synthesize patMrno,currentIndex;
@synthesize activityController, service, patients;
@synthesize capturedImages, imagePicker, btnChecked;
@synthesize patAllergy, patVitals, patHealth, patmrno,pharmacyOrderArray;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.service = [[[_GMDocService alloc] init] autorelease];
    
    if (self.capturedImages == Nil) {
		self.capturedImages = [NSMutableArray array];
	}
    
    self.navigationItem.titleView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mCURA.png"]] autorelease];    
    
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(selectLogout:)];
    bi.style = UIBarButtonItemStyleBordered;
    self.navigationItem.rightBarButtonItem = bi;
    [bi release];
      
    NSArray *subviews = [self.txtSearch subviews] ;
    for(id subview in subviews) {
        if([subview isKindOfClass:[UITextField class]]) {
            [(UITextField*)subview setReturnKeyType:UIReturnKeySearch];
        }
    }

    if(pat==nil)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
    res = [[DataExchange getLoginResponse] objectAtIndex:0];
    [self.service getSubTenantIdInvocation:[res.userRoleID stringValue] delegate:self];
    currSubTenIndex = -1;
    tblSubTenants.layer.cornerRadius = 10;
    self.tblView.rowHeight = 70;
    [self tabBarController].delegate = self;
    
    if(self.pat!=nil)
        [self openCurrentVisitDetailController];
}

-(void)viewWillAppear:(BOOL)animated{
    UIToolbar* toolsLeft = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44.01)];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:3];
    UIBarButtonItem* bi = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back.png"] style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
    [buttons addObject:bi];
    [bi release];
    NSString* str=[(UserDetail*)[[DataExchange getUserResult] objectAtIndex:0] u_name];
    bi = [[UIBarButtonItem alloc] initWithTitle:@"Welcome" style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:bi];
    [bi release];
    bi = [[UIBarButtonItem alloc] initWithTitle:str style:UIBarButtonItemStylePlain target:self action:nil];
    [buttons addObject:bi];
    [bi release];
    [toolsLeft setItems:buttons animated:NO];
    [buttons release];
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolsLeft] autorelease];
    [toolsLeft release];
}

-(void)selectLogout:(id)sender{
    UINavigationController* nvc = self.tabBarController.navigationController;
	NSArray* controllers = [nvc viewControllers];
	UIViewController* tvc = Nil;
	for (UIViewController* vc in controllers) {
        if ([vc isKindOfClass:[STPNLoggedIn class]]) {
			tvc = (UIViewController *)(STPNLoggedIn*)vc;
			break;
		}
	}
    [self.tabBarController.navigationController popToViewController:tvc animated:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}


-(void) getPatientContactDetailDidFinish:(GetPatientContactDetail*)invocation
                            withPatients:(NSArray*)patient_
                               withError:(NSError*)error{
}

-(void)getPatientInvocationDidFinish:(GetPatientInvocation*)invocation
                         withPatients:(NSArray*)patient_
                           withError:(NSError*)error{
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
    if(!error){
        if([patient_ count] > 0){
            self.patients = patient_;
            [self.tblView reloadData];
            [NSThread detachNewThreadSelector:@selector(getImagesLazily) toTarget:self withObject:nil];
        }
        else{
            [Utils showAlert:@"Record not found!" Title:@""];
        }            
    }
}

-(void)reloadTable{
    [self.tblView reloadData];
}

-(void)getImagesLazily{
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    for (int i=0; i<self.patients.count; i++) {
        NSString* imagePath = [(Patient*)[self.patients objectAtIndex:i] imagepath];
        if(![imagePath isKindOfClass:[NSNull class]]){
            imagePath = [imagePath stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            NSString* urlString = [NSString stringWithFormat:@"http://%@/%@",[DataExchange getDomainUrl],imagePath];
            UIImage* img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]]];
            if(img)
                [self.capturedImages addObject:img];
            else
                [self.capturedImages addObject:[UIImage imageNamed:@"No_Image.png"]];
        }
        else{
            [self.capturedImages addObject:[UIImage imageNamed:@"No_Image.png"]];
        }
    }
    [pool release];
    [self performSelectorOnMainThread:@selector(reloadTable) withObject:Nil waitUntilDone:NO];
}

-(void)GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation *)invocation 
                     withSubTenantIds:(NSArray *)subTenantIds
                            withError:(NSError *)error{
    if(!error){
        arraySubTenants = [[NSMutableArray alloc] initWithArray:subTenantIds];
        arraySubTenantIds = [[NSMutableArray alloc] init];
        for (int i=0; i<arraySubTenants.count; i++) {
            [arraySubTenantIds addObject:[(SubTenant*)[arraySubTenants objectAtIndex:i] SubTenantId]];
        }
        [tblSubTenants setFrame:CGRectMake(tblSubTenants.frame.origin.x, tblSubTenants.frame.origin.y, tblSubTenants.frame.size.width, 20+44*subTenantIds.count)];
        [tblSubTenants reloadData];
    }
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [self.txtSearch resignFirstResponder];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self.txtSearch resignFirstResponder];
    [self.capturedImages removeAllObjects];
    if([[self.txtSearch.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] > 0){
        if(currSubTenIndex>=0){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Searching..."];
            NSString* str = [NSString stringWithFormat:@"%d",currSubTenIndex];
            [self.service getPatientInvocation:[res.userRoleID stringValue] Searchkey:self.txtSearch.text Sub_tenant_id:str delegate:self];
        }
        else{
            [Utils showAlert:@"Please select a sub tenant!" Title:@"Error"];
        }
    }
    else{
        [Utils showAlert:@"Enter text for search!" Title:@"Alert"];
    }
}

- (IBAction)clickCheckBtn:(id)sender{
    if(keepmeAppointmentBool){
        keepmeAppointmentBool = FALSE;
        [self.btnChecked setImage:[UIImage imageNamed:@"checked1.png"] forState:UIControlStateNormal];
    }
    else{
        keepmeAppointmentBool = TRUE;
        [self.btnChecked setImage:[UIImage imageNamed:@"check1.png"] forState:UIControlStateNormal];
    }
}

- (IBAction)btnSubTensPressed{
    tblSubTenants.hidden = false;
}
#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==tblView)
        return self.patients.count;
    else
        return arraySubTenants.count;
}

// cell_Details
// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* sRowCell = @"RowCell";
    
    if(tableView==tblView){
        cell = (AppointmentTblCell*)[self.tblView dequeueReusableCellWithIdentifier:sRowCell];	
        if (Nil == cell) {
            cell = [AppointmentTblCell createTextRowWithOwner:self];
        }
        
        Patient *p = [self.patients objectAtIndex:indexPath.row];
        if(![p.Patname isKindOfClass:[NSNull class]])
            cell.lblName.text = p.Patname;
        cell.lblMrno.text = [p.MRNO stringValue];
        
        if(![p.GenderId isKindOfClass:[NSNull class]]){
            if ([[p.GenderId stringValue] isEqualToString:@"1"]) {
                cell.lblSex.text = @"Male";
            }
            else if ([[p.GenderId stringValue] isEqualToString:@"2"]) {
                cell.lblSex.text = @"Female";
            }
        }
        if(![p.dob isKindOfClass:[NSNull class]])
            if ( [p.dob length]!=0) {
                NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
                [df setDateFormat:@"dd-MM-yyyy"];
                NSString *dob;
                dob = [PharmacyViewController AgeFromString:[df stringFromDate:[PharmacyViewController mfDateFromDotNetJSONString:p.dob]]];
                dob = [dob stringByReplacingOccurrencesOfString:@"Years" withString:@""];
                cell.lblAge.text = dob;
        }
        if(self.capturedImages.count>indexPath.row){
            cell.imgView.image = [self.capturedImages objectAtIndex:indexPath.row];
        }
        cell.lblMobNo.text = [NSString stringWithFormat:@"+91%@",[[(PatientContactDetails*)[p.PatientContactDetails objectAtIndex:0] Mobile] stringByReplacingOccurrencesOfString:@"+91" withString:@""]];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cellT = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cellT == nil) {
            cellT = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        }
        cellT.textLabel.text = [(SubTenant*)[arraySubTenants objectAtIndex:indexPath.row] SubTenantName];
        return cellT;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(tableView == self.tblView){
        Patient *p = [self.patients objectAtIndex:indexPath.row];
        self.pat = [[[Patdemographics alloc] init] autorelease];
        self.pat.patDemoID = p.PatDemoid;
        self.pat.contactID = p.ContactId;
        self.pat.addressID = p.AddressId;
        self.pat.genderID = p.GenderId;
        self.pat.patDOB = p.dob;
        self.pat.patName = p.Patname;
        self.patmrno = [p.MRNO stringValue];
        self.patMrno = [p.MRNO stringValue];
        self.patients = nil;
        self.txtSearch.text = @"";
        [self.tblView reloadData];
        [DataExchange setScheduleDayIndex:0];
        visitDetailController = [[CurrentVisitDetailViewController alloc] init];
        visitDetailController.pat = self.pat;
        visitDetailController.phone = phone;
        visitDetailController.currentIndex = currentIndex;
        visitDetailController.hideNextPatientButton = true;
        visitDetailController.mrno = (self.patmrno==nil?self.patMrno:self.patmrno);
        [visitDetailController setPatientDetailsLabels:self.pat];
        [self.navigationController pushViewController:visitDetailController animated:YES];
    }else if(tableView==tblSubTenants){
        UITableViewCell *cellD = [tblSubTenants cellForRowAtIndexPath:indexPath];
        [btnSubTenants setTitle:cellD.textLabel.text forState:UIControlStateNormal];
        NSNumber* subT = [arraySubTenantIds objectAtIndex:indexPath.row];
        currSubTenIndex = [subT integerValue];
        tblSubTenants.hidden = true;
    }
}

-(void)openCurrentVisitDetailController{
    visitDetailController = [[CurrentVisitDetailViewController alloc] init];
    visitDetailController.pat = self.pat;
    visitDetailController.phone = phone;
    visitDetailController.currentIndex = currentIndex;
    visitDetailController.mrno = (self.patmrno==nil?self.patMrno:self.patmrno);
    [visitDetailController setPatientDetailsLabels:self.pat];
    [self.navigationController pushViewController:visitDetailController animated:YES];
}

-(void) closePopup
{
    [self.popoverController  dismissPopoverAnimated:NO];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblSubTenants.hidden = true;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(void)back:(id)sender{
    UITabBarController *tabBar = [self tabBarController];
    [tabBar setSelectedIndex:0];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end

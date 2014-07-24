//
//  AddHAViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 20/04/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddHAViewController.h"
#import "proAlertView.h"
#import "Allergy.h"
#import "PatHealthCondition.h"
#import "PatHealthConType.h"
#import "PatVital.h"
#import <QuartzCore/QuartzCore.h>

@implementation AddHAViewController

@synthesize healthAllergyOrVital,popover,userRoleId,mrNo,subTenId;
@synthesize activityController,delegate,service,vitalsArray,typeArray,nameArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.service = [[[_GMDocService alloc] init] autorelease];
    switch (healthAllergyOrVital) {
        case 0:
            [titleLbl setText:@"Past History"];
            [firstLbl setText:@"Condition Type"];
            [secondLbl setText:@"Health Condition"];
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getPatientHealthInvocation:self.userRoleId Mrno:YES delegate:self];
            [self.service getPatientHealthInvocation:self.userRoleId Mrno:NO delegate:self];
            vitalView.hidden = true;
            break;
        case 1:
            [titleLbl setText:@"Add Allergy"];
            [firstLbl setText:@"Allergy Type"];
            [secondLbl setText:@"Allergy Name"];
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getAllergyInvocation:self.userRoleId delegate:self];
            vitalView.hidden = true;
            break;
        case 2:
            [titleLbl setText:@"Add Vital"];
            [firstLbl setText:@"Past Allergy type"];
            [secondLbl setText:@"Allergy ID"];
            vitalView.hidden = false;
            [vitalTable reloadData];
            break;
        default:
            break;
    }
    typeTable.layer.cornerRadius = 10;
    nameTable.layer.cornerRadius = 10;
    vitalTable.layer.cornerRadius = 10;
    reading.autocorrectionType = UITextAutocorrectionTypeNo;
    otherInfo.autocorrectionType = UITextAutocorrectionTypeNo;
    remarks.autocorrectionType = UITextAutocorrectionTypeNo;

}

#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == typeTable)
        return [typeArray count];
    else if(tableView == nameTable)
        return [nameArray count];
    else
        return [vitalsArray count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    if(tableView == typeTable){
        if(healthAllergyOrVital==1)
            cell.textLabel.text = [(Allergy*)[typeArray objectAtIndex:indexPath.row] AllergyTypeProperty];
        else
            cell.textLabel.text = [(PatHealthConType*)[typeArray objectAtIndex:indexPath.row] HConTypeProperty];
        return cell;
    }
    else if(tableView == nameTable){
        if(healthAllergyOrVital==1)
            cell.textLabel.text = [(Allergy*)[nameArray objectAtIndex:indexPath.row] AllergyName];
        else
            cell.textLabel.text = [(PatHealthCondition*)[nameArray objectAtIndex:indexPath.row] HCondition];
        return cell;
    }
    else if(tableView == vitalTable){
        cell.textLabel.text = [(PatVital*)[vitalsArray objectAtIndex:indexPath.row] VitalName];
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    if(tableView == typeTable){
        [btnType setTitle:cell.textLabel.text forState:UIControlStateNormal];
        typeTable.hidden = true;
        if(healthAllergyOrVital==1){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
            [self.service getPatientAllergyInvocation:self.userRoleId AllergyId:[[(Allergy*)[typeArray objectAtIndex:indexPath.row] AllergyTypeId] stringValue] delegate:self];
        }
        typeIndex = indexPath.row;
    }
    else if(tableView == nameTable){
        [btnName setTitle:cell.textLabel.text forState:UIControlStateNormal];
        nameTable.hidden = true;
        nameIndex = indexPath.row;
    }
    else if(tableView == vitalTable){
        [btnVital setTitle:cell.textLabel.text forState:UIControlStateNormal];
        vitalTable.hidden = true;
        vitalIndex = indexPath.row;
    }
}

#pragma mark invocations

-(void)getAllergyInvocationDidFinish:(GetAllergyInvocation *)invocation withAllergys:(NSArray *)allergys withError:(NSError *)error{
    if(!error){
        typeArray = [[NSMutableArray alloc] initWithArray:allergys];
        [typeTable reloadData];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)getPatientAllergyInvocationDidFinish:(GetPatientAllergyInvocation *)invocation withAllergys:(NSArray *)allergys withError:(NSError *)error{
    if(!error && allergys.count>0){
        [btnName setTitle:@"--Select--" forState:UIControlStateNormal];
        nameArray = [[NSMutableArray alloc] initWithArray:allergys];
        [nameTable reloadData];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)getPatientHealthConditionInvocationDidFinish:(GetPatientHealthInvocation *)invocation withHealthConditions:(NSArray *)healths withError:(NSError *)error{
    if(!error){
        [btnName setTitle:@"--Select--" forState:UIControlStateNormal];
        nameArray = [[NSMutableArray alloc] initWithArray:healths];
        [nameTable reloadData];
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(void)getPatientHealthConditionTypeInvocationDidFinish:(GetPatientHealthInvocation *)invocation withHealthConditionTypes:(NSArray *)healths withError:(NSError *)error{
    if(!error){
        typeArray = [[NSMutableArray alloc] initWithArray:healths];
        [typeTable reloadData];
    }
}

#pragma mark others

- (void) closePopUpDate:(NSString*)dt{
    NSString* date = [dt stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
    [btnDate setTitle:date forState:UIControlStateNormal];
    [self.popover dismissPopoverAnimated:YES];
}

-(IBAction) clickFromDate:(id)sender{
    [self.popover dismissPopoverAnimated:YES];
    UIButton *theSender = sender;
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    addController.delegate = self;
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    [self.popover presentPopoverFromRect:CGRectMake(0.00,00.00, 25.00, 40.00) inView:theSender permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
    [addController release];
}

-(IBAction) clickTypeBtn:(id)sender{
    typeTable.hidden = false;
}

-(IBAction) clickNameBtn:(id)sender{
    nameTable.hidden = false;
}

-(IBAction) clickVitalBtn:(id)sender{
    vitalTable.hidden = false;
}

-(IBAction)submitBtnPressed:(id)sender{
    saveAlertView= [[proAlertView alloc] initWithTitle:nil message:@"Submit?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [saveAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [saveAlertView show];
}

-(IBAction)cancelBtnPrsd:(id)sender{
    closeAlertView= [[proAlertView alloc] initWithTitle:@"Close?" message:@"Are you sure?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"YES",nil];
    [closeAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [closeAlertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        if(alertView==closeAlertView){
            if(self.delegate != nil){
                [self.delegate closePopup];
            }
        }
        else if(alertView==saveAlertView){
            if (!self.activityController) {
                self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Submitting data..."];
            }
            [self.view endEditing:TRUE];
            NSString* dataToPost;
            NSURL* myUrl;
            switch (healthAllergyOrVital) {
                case 0:
                    dataToPost = [NSString stringWithFormat:@"{\"UserRoleID\":%@,\"Existsfrom\":\"%@\",\"HealthConditionID\":%d,\"HealthConditionTypeID\":%d,\"Mrno\":\"%@\"}",self.userRoleId,btnDate.titleLabel.text,[[(PatHealthCondition*)[nameArray objectAtIndex:nameIndex] HConId] integerValue],[[(PatHealthConType*)[typeArray objectAtIndex:typeIndex] HConTypeId] integerValue],self.mrNo];
                    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostHealthCondtion",[DataExchange getbaseUrl]]] autorelease];
                    break;
                case 1:
                    dataToPost = [NSString stringWithFormat:@"{\"UserRoleID\":%@,\"AllergyId\":%d,\"subtenantid\":%@,\"Existsfrom\":\"%@\",\"MRNO\":\"%@\"}",self.userRoleId,[[(Allergy*)[nameArray objectAtIndex:nameIndex] AllergyId] integerValue],self.subTenId,btnDate.titleLabel.text,self.mrNo];
                    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostAllergy",[DataExchange getbaseUrl]]] autorelease];
                    break;
                case 2:
                    dataToPost = [NSString stringWithFormat:@"{\"UserRoleID\":%@,\"VitalOtherInfo\":\"%@\",\"VitalReading\":\"%@\",\"VitalRemarks\":\"%@\",\"Mrno\":\"%@\",\"VitalNatureId\":%d}",self.userRoleId,otherInfo.text,reading.text,remarks.text,self.mrNo,[[(PatVital*)[vitalsArray objectAtIndex:vitalIndex] VitalNatureId] integerValue]];
                    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostPatientVital",[DataExchange getbaseUrl]]] autorelease];
                    break;
                default:
                    break;
            }
            NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
            [request setURL:myUrl];
            [request setHTTPMethod:@"POST"];
            [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
            [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]]; 
            NSURLConnection *theConnection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
            if (!theConnection) {
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
        }
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{	
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
    [self.delegate labOrderDidSubmit];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {

}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    nameTable.hidden = true;
    typeTable.hidden = true;
    vitalTable.hidden = true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isNumeric=FALSE;
	if ([string length] == 0) 
	{
		isNumeric=TRUE;
	}
	else
	{
		if ( [string compare:@"0"]==0 || [string compare:@"1"]==0
			|| [string compare:@"2"]==0 || [string compare:@"3"]==0
			|| [string compare:@"4"]==0 || [string compare:@"5"]==0
			|| [string compare:@"6"]==0 || [string compare:@"7"]==0
			|| [string compare:@"8"]==0 || [string compare:@"9"]==0
            || [string compare:@"."]==0)
		{
			isNumeric=TRUE;
		}
		else 
		{
			unichar mychar=[string characterAtIndex:0];
			if (mychar==46)
			{
				int i;
				for (i=0; i<[textField.text length]; i++)
				{
					unichar c = [textField.text characterAtIndex: i];
					if(c==46)
						return FALSE;
				}
                isNumeric=TRUE;
			}
		}
	}
	return isNumeric;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end

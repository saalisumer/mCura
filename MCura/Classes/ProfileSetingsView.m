//
//  ProfileSetingsView.m
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSetingsView.h"
#import "proAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "DataExchange.h"
#import "Response.h"

@implementation ProfileSetingsView

@synthesize txtName, txtDob, txtMobile, txtEmail, btnArea, btnGender, genders, activityController,staticOverlayView,popover;
@synthesize service = _service,txtAddress,txtSkypeId,txtOptEmail,txtExtension,txtFixedLine,txtOptMobile;
@synthesize tblGenders, tblAreas, areas,tblCity,tblStates,tblCountry,btnCity,btnState,btnCountry,areaIds,arrayCityIds,arrayStateIds,docStateId,docCityId,tblDocCredo,tblPrintSettings,tblDisplaySettings,arrayDisplaySettings,arrayPrintSettings;
@synthesize arrayCities,arrayState,arrayCountries,mParentController,lblAddress2,txtAddress2,zipcodeStr;
@synthesize lblDob,lblName,lblEmail,lblMobile,lblAddress,lblSkypeId,lblOptEmail,lblExtension,lblFixedLine,lblOptMobile;

-(id)initWithParent:(UserAccountViewController*)parent{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"ProfileSetingsView" owner: self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    postStatus=0;
    childNavBar.layer.cornerRadius = 5.0;
    self.mParentController = parent;
    self.genders = [[NSMutableArray alloc] initWithObjects:@"M", @"F", nil];
    self.areas = [[NSMutableArray alloc] init];
    self.arrayCities = [[NSMutableArray alloc] init];
    self.arrayCountries = [[NSMutableArray alloc] init];
    self.arrayState = [[NSMutableArray alloc] init];
    self.arrayCityIds = [[NSMutableArray alloc] init]; 
    self.areaIds = [[NSMutableArray alloc] init];
    self.arrayStateIds = [[NSMutableArray alloc] init];
    self.service = [[[_GMDocService alloc] init] autorelease];
    self.tblAreas.layer.cornerRadius = 10;
    self.tblGenders.layer.cornerRadius = 10;
    self.tblCity.layer.cornerRadius = 10;
    self.tblCountry.layer.cornerRadius = 10;
    self.tblStates.layer.cornerRadius = 10;
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:parent withLabel:@"Loading ..."];
    areaId = [[DataExchange getAreaID] integerValue];
    NSString* url = [NSMutableString stringWithFormat:@"%@GetArea?AreaId=%d",[DataExchange getbaseUrl],areaId];
    [self.service getStringResponseInvocation:url Identifier:@"GetDoctorCity" delegate:self];
    
    url = [NSMutableString stringWithFormat:@"%@GetUserDetails?sub_tenant_id=%d&UserRoleID=%@",[DataExchange getbaseUrl],[DataExchange getSubTenantId],[DataExchange getUserRoleId]];
    [self.service getStringResponseInvocation:url Identifier:@"GetUserDetails" delegate:self];

    return self;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if(textField==txtDob){
        [txtDob resignFirstResponder];
        return;
    }
    if(textField==txtEmail || textField==txtName || textField==txtSkypeId || textField==txtAddress || textField==txtAddress2 || textField==txtFixedLine || textField==txtMobile){
        return;
    }
	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
	static const CGFloat MINIMUM_SCROLL_FRACTION = 0.2;
    static const CGFloat MAXIMUM_SCROLL_FRACTION = 0.8;
    static const CGFloat PORTRAIT_KEYBOARD_HEIGHT = 216;
    static const CGFloat LANDSCAPE_KEYBOARD_HEIGHT = 300;
	
    CGRect textFieldRect =[self convertRect:textField.bounds fromView:textField];
    CGRect viewRect =[self convertRect:self.bounds fromView:self];
	CGFloat midline = textFieldRect.origin.y + 5.0 * textFieldRect.size.height;
    CGFloat numerator = midline - viewRect.origin.y - MINIMUM_SCROLL_FRACTION * viewRect.size.height;
    CGFloat denominator = (MAXIMUM_SCROLL_FRACTION - MINIMUM_SCROLL_FRACTION) * viewRect.size.height;
    CGFloat heightFraction = numerator / denominator;
	
    if (heightFraction < 0.0)
    {
        heightFraction = 0.0;
    }
    else if (heightFraction > 1.0)
    {
        heightFraction = 1.0;
    }
	
	UIInterfaceOrientation orientation =[[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait ||orientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        animatedDistance = floor(PORTRAIT_KEYBOARD_HEIGHT * heightFraction);
    }
    else
    {
        animatedDistance = floor(LANDSCAPE_KEYBOARD_HEIGHT * heightFraction);
    }
	
	CGRect viewFrame = self.frame;
    viewFrame.origin.y -= animatedDistance;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
	[self setFrame:viewFrame];
    [UIView commitAnimations];
	
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(textField.tag>=140){
        [self.arrayPrintSettings replaceObjectAtIndex:(textField.tag-140) withObject:textField.text];
    }
    else if(textField.tag>=110){
        [self.arrayDisplaySettings replaceObjectAtIndex:(textField.tag-110) withObject:textField.text];
    }
	if(textField==txtDob){
        //[txtDob resignFirstResponder];
        return;
    }
    if(textField==txtEmail || textField==txtName || textField==txtSkypeId || textField==txtAddress || textField==txtAddress2 || textField==txtFixedLine || textField==txtMobile){
        return;
    }
	static const CGFloat KEYBOARD_ANIMATION_DURATION = 0.3;
	CGRect viewFrame = self.frame;
    viewFrame.origin.y += animatedDistance;
	[UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:KEYBOARD_ANIMATION_DURATION];
    [self setFrame:viewFrame];
    [UIView commitAnimations];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return YES;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 36.0;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == self.tblGenders)
        return self.genders.count;
    else if(tableView == self.tblCity)
        return self.arrayCities.count;
    else if(tableView == self.tblCountry)
        return self.arrayCountries.count;
    else if(tableView == self.tblStates)
        return self.arrayState.count;
    else if(tableView == self.tblDisplaySettings)
        return self.arrayDisplaySettings.count;
    else if(tableView == self.tblPrintSettings)
        return self.arrayPrintSettings.count;
    else if(tableView == self.tblDocCredo)
        return 1;
    else 
        return self.areas.count;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if(tableView == self.tblGenders){
        UITableViewCell *cell = [self.tblGenders dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.genders objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblCity){
        UITableViewCell *cell = [self.tblCity dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayCities objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblCountry){
        UITableViewCell *cell = [self.tblCountry dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayCountries objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblStates){
        UITableViewCell *cell = [self.tblStates dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrayState objectAtIndex:indexPath.row];
        return cell;
    }
    else if(tableView == self.tblDisplaySettings){
        UITableViewCell *cell = [self.tblDisplaySettings dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UITextField class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(4, 5,280 , 31)];
        if(![[self.arrayDisplaySettings objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]])
            field.text = [self.arrayDisplaySettings objectAtIndex:indexPath.row];
        else
            field.text = @"";
        field.delegate = self;
        field.tag = 110+indexPath.row;
        [cell addSubview:field];
        [field release];
        
        return cell;
    }
    else if(tableView == self.tblPrintSettings){
        UITableViewCell *cell = [self.tblPrintSettings dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UITextField class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        UITextField* field = [[UITextField alloc] initWithFrame:CGRectMake(4, 5,280 , 31)];
        if(![[self.arrayPrintSettings objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]])
            field.text = [self.arrayPrintSettings objectAtIndex:indexPath.row];
        else
            field.text = @"";
        [cell addSubview:field];
        field.tag = 140+indexPath.row;
        field.delegate = self;
        [field release];
        return cell;
    }
    else if(tableView == self.tblDocCredo){
        UITableViewCell *cell = [self.tblDocCredo dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UILabel class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
        UILabel* lblUsrName = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, 99, 40)] autorelease];
        lblUsrName.backgroundColor = [UIColor clearColor];
        lblUsrName.textColor = [UIColor blackColor];
        lblUsrName.textAlignment = UITextAlignmentCenter;
        lblUsrName.text = [NSString stringWithFormat:@"%@",[(Response*)[[DataExchange getLoginResponse] objectAtIndex:0] loginName]];
        [cell addSubview:lblUsrName];
        
        UIButton* btnPswd = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPswd setFrame:CGRectMake(100, 0, 99, 40)];
        btnPswd.titleLabel.textAlignment = UITextAlignmentCenter;
        [btnPswd setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnPswd addTarget:self action:@selector(clickChangePassword:) forControlEvents:UIControlEventTouchUpInside];
        [btnPswd setTitle:@"******" forState:UIControlStateNormal];
        [cell addSubview:btnPswd];
        
        UIButton* btnPin = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPin setFrame:CGRectMake(200, 0, 99, 40)];
        btnPin.titleLabel.textAlignment = UITextAlignmentCenter;
        [btnPin setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [btnPin addTarget:self action:@selector(clickChangePin:) forControlEvents:UIControlEventTouchUpInside];
        [btnPin setTitle:[NSString stringWithFormat:@"%d",[[(Response*)[[DataExchange getLoginResponse] objectAtIndex:0] pin] integerValue]] forState:UIControlStateNormal];
        [cell addSubview:btnPin];
        
        UILabel* lblRole = [[[UILabel alloc] initWithFrame:CGRectMake(300, 0, 99, 40)] autorelease];
        lblRole.backgroundColor = [UIColor clearColor];
        lblRole.textAlignment = UITextAlignmentCenter;
        lblRole.text = @"Doctor";
        [cell addSubview:lblRole];
        
        return cell;
    }
    else{
        UITableViewCell *cell = [self.tblAreas dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.areas objectAtIndex:indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if(tableView == self.tblGenders){
        [self.btnGender setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblGenders.hidden = YES;
    }
    else if(tableView == self.tblCity){
        [self.btnCity setTitle:cell.textLabel.text forState:UIControlStateNormal];
        docCityId = [[arrayCityIds objectAtIndex:indexPath.row] integerValue];
        NSString* url = [NSMutableString stringWithFormat:@"%@GetCityArea?cityId=%d",[DataExchange getbaseUrl],docCityId];
        [self.service getStringResponseInvocation:url Identifier:@"GetAreaFromCity" delegate:self];
        self.tblCity.hidden = YES;
        pendingConnections++;
    }
    else if(tableView == self.tblCountry){
        [self.btnCountry setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblCountry.hidden = YES;
    }
    else if(tableView == self.tblStates){
        [self.btnState setTitle:cell.textLabel.text forState:UIControlStateNormal];
        docStateId = [[arrayStateIds objectAtIndex:indexPath.row] integerValue];
        NSString* url = [NSMutableString stringWithFormat:@"%@GetCity2?StateID=%d",[DataExchange getbaseUrl],docStateId];
        [self.service getStringResponseInvocation:url Identifier:@"GetCityFromState" delegate:self];
        self.tblStates.hidden = YES;
        pendingConnections++;
    }
    else if(tableView == self.tblDocCredo){
//        [self clickChangePassword:nil];
    }
    else{
        areaId = [[areaIds objectAtIndex:indexPath.row] integerValue];
        [self.btnArea setTitle:cell.textLabel.text forState:UIControlStateNormal];
        self.tblAreas.hidden = YES;
    }
}

-(IBAction) clickGenderBtn:(id)sender{
    self.tblGenders.hidden = NO;
}

-(IBAction) clickAreaBtn:(id)sender{
    self.tblAreas.hidden = NO;
}

-(IBAction) clickCityBtn:(id)sender{
    self.tblCity.hidden = NO;
}

-(IBAction) clickStateBtn:(id)sender{
    self.tblStates.hidden = NO;
}

-(IBAction) clickCountryBtn:(id)sender{
    self.tblCountry.hidden = NO;
}

-(void)GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                 withResponseString:(NSString *)responseString 
                     withIdentifier:(NSString *)identifier 
                          withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetCity"]){
            if(response.count>0){
                NSString* url = [NSMutableString stringWithFormat:@"%@GetCityArea?cityId=%d",[DataExchange getbaseUrl], docCityId];
                [self.service getStringResponseInvocation:url Identifier:@"GetArea" delegate:self];
                
                NSDictionary* dictTemp;
                for (int i=0; i<response.count; i++) {
                    dictTemp = [response objectAtIndex:i];
                    if([[dictTemp objectForKey:@"CityId"] integerValue] == docCityId){
                        [btnCity setTitle:[dictTemp objectForKey:@"City"] forState:UIControlStateNormal];
                        docStateId = [[dictTemp objectForKey:@"StateId"] integerValue];
                        url = [NSMutableString stringWithFormat:@"%@GetState_StateID?StateID=%@",[DataExchange getbaseUrl],[dictTemp objectForKey:@"StateId"]];
                        [self.service getStringResponseInvocation:url Identifier:@"GetState" delegate:self];
                        break;
                    }
                }
                
                for(int i=0;i<response.count;i++){
                    [self.arrayCities addObject:[[response objectAtIndex:i] objectForKey:@"City"]];
                    [self.arrayCityIds addObject:[[response objectAtIndex:i] objectForKey:@"CityId"]];
                }
                
                pendingConnections++;
                [self.tblCity reloadData];
            }else{
                pendingConnections=0;
            }
        }
        else if([identifier isEqualToString:@"GetCountry"]){
            pendingConnections--;
            if(response.count>0){
                NSDictionary* dictTemp = [response objectAtIndex:0];
                [self.arrayCountries addObject:[dictTemp objectForKey:@"CountryProperty"]];
                [btnCountry setTitle:[self.arrayCountries objectAtIndex:0] forState:UIControlStateNormal];
                [self.tblCountry reloadData];
            }
        }
        else if([identifier isEqualToString:@"GetState"]){
            pendingConnections--;
            [self.arrayState removeAllObjects];
            [self.arrayStateIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if([[dictTemp objectForKey:@"StateId"] integerValue] == docStateId){
                    [btnState setTitle:[dictTemp objectForKey:@"StateProperty"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"StateProperty"] isKindOfClass:[NSNull class]]){
                    [self.arrayState addObject:[dictTemp objectForKey:@"StateProperty"]];
                    [self.arrayStateIds addObject:[dictTemp objectForKey:@"StateId"]];
                }
            }
            [self.tblStates reloadData];
        }
        else if([identifier isEqualToString:@"GetArea"]){
            pendingConnections--;
            [self.areas removeAllObjects];
            [self.areaIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if([[dictTemp objectForKey:@"AreaId"] integerValue] == areaId){
                    [btnArea setTitle:[dictTemp objectForKey:@"Area"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"Area"] isKindOfClass:[NSNull class]]){
                    [self.areas addObject:[dictTemp objectForKey:@"Area"]];
                    [self.areaIds addObject:[dictTemp objectForKey:@"AreaId"]];
                }
            }
            if (self.activityController) {
                [self.activityController dismissActivity];
                self.activityController = Nil;
            }
            [self.tblAreas reloadData];
        }
        else if([identifier isEqualToString:@"GetDoctorCity"]){
            docCityId = [(NSNumber*)[(NSDictionary*)response objectForKey:@"CityId"] integerValue];
            NSString* url = [NSMutableString stringWithFormat:@"%@GetCity_Area?AreaId=%d",[DataExchange getbaseUrl],areaId];
            [self.service getStringResponseInvocation:url Identifier:@"GetCity" delegate:self];
            
            NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease]; 
            url = [NSMutableString stringWithFormat:@"http://%@GetUser?UserRoleID=%@",[DataExchange getbaseUrl],[DataExchange getUserRoleId]];
            [request setURL:[NSURL URLWithString:url]];
            [request setHTTPMethod:@"GET"];
            getUserConn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        }
        else if([identifier isEqualToString:@"GetAreaFromCity"]){
            pendingConnections--;
            
            [self.areas removeAllObjects];
            [self.areaIds removeAllObjects];
            for (int i=0; i<response.count; i++) {
                NSDictionary* dictTemp = [response objectAtIndex:i];
                if(i==0){
                    [btnArea setTitle:[dictTemp objectForKey:@"Area"] forState:UIControlStateNormal];
                }
                if(![[dictTemp objectForKey:@"Area"] isKindOfClass:[NSNull class]]){
                    [self.areas addObject:[dictTemp objectForKey:@"Area"]];
                    [self.areaIds addObject:[dictTemp objectForKey:@"AreaId"]];
                }
            }
            [self.tblAreas reloadData];
        }
        else if([identifier isEqualToString:@"GetCityFromState"]){
            pendingConnections--;
            [self.arrayCities removeAllObjects];
            [self.arrayCityIds removeAllObjects];
            if(response.count>0){
                NSDictionary* dictTemp = [response objectAtIndex:0];
                [btnCity setTitle:[dictTemp objectForKey:@"City"] forState:UIControlStateNormal];
                docStateId = [[dictTemp objectForKey:@"StateId"] integerValue];
            }
            
            for(int i=0;i<response.count;i++){
                [self.arrayCities addObject:[[response objectAtIndex:i] objectForKey:@"City"]];
                [self.arrayCityIds addObject:[[response objectAtIndex:i] objectForKey:@"CityId"]];
            }
            [self.tblCity reloadData];
        }
        else if([identifier isEqualToString:@"GetUserDetails"]){
            if([response isKindOfClass:[NSNull class]]){
                return;
            }
            NSDictionary* dictDisp = [(NSDictionary*)response objectForKey:@"DisplayLabel"];
            NSDictionary* dictPrint = [(NSDictionary*)response objectForKey:@"PrintLabel"];
            self.arrayPrintSettings = [[NSMutableArray alloc] init];
            self.arrayDisplaySettings = [[NSMutableArray alloc] init];
            if(![dictDisp isKindOfClass:[NSNull class]]){
                displaySettingsId = [[dictDisp objectForKey:@"UserDisplayId"] integerValue];
                if(![dictDisp objectForKey:@"Line1"])
                    [self.arrayDisplaySettings addObject:@""];
                else
                    [self.arrayDisplaySettings addObject:[dictDisp objectForKey:@"Line1"]];
                
                if(![dictDisp objectForKey:@"Line2"])
                    [self.arrayDisplaySettings addObject:@""];
                else
                    [self.arrayDisplaySettings addObject:[dictDisp objectForKey:@"Line2"]];
                if(![dictDisp objectForKey:@"Line3"])
                    [self.arrayDisplaySettings addObject:@""];
                else
                    [self.arrayDisplaySettings addObject:[dictDisp objectForKey:@"Line3"]];
                if(![dictDisp objectForKey:@"Line4"])
                    [self.arrayDisplaySettings addObject:@""];
                else
                    [self.arrayDisplaySettings addObject:[dictDisp objectForKey:@"Line4"]];
            }else{
                [self.arrayDisplaySettings addObject:@""];
                [self.arrayDisplaySettings addObject:@""];
                [self.arrayDisplaySettings addObject:@""];
                [self.arrayDisplaySettings addObject:@""];
            }
            if(![dictPrint isKindOfClass:[NSNull class]]){
                printSettingsId = [[dictPrint objectForKey:@"UserPrintId"] integerValue];
                if([dictPrint objectForKey:@"Line1"])
                    [self.arrayPrintSettings addObject:[dictPrint objectForKey:@"Line1"]];
                else
                    [self.arrayPrintSettings addObject:@""];
                if([dictPrint objectForKey:@"Line2"])
                    [self.arrayPrintSettings addObject:[dictPrint objectForKey:@"Line2"]];
                else
                    [self.arrayPrintSettings addObject:@""];
                if([dictPrint objectForKey:@"Line3"])
                    [self.arrayPrintSettings addObject:[dictPrint objectForKey:@"Line3"]];
                else
                    [self.arrayPrintSettings addObject:@""];
                if([dictPrint objectForKey:@"Line4"])
                    [self.arrayPrintSettings addObject:[dictPrint objectForKey:@"Line4"]];
                else
                    [self.arrayPrintSettings addObject:@""];
            }else{
                [self.arrayPrintSettings addObject:@""];
                [self.arrayPrintSettings addObject:@""];
                [self.arrayPrintSettings addObject:@""];
                [self.arrayPrintSettings addObject:@""];
            }
            [self.tblDisplaySettings reloadData];
            [self.tblPrintSettings reloadData];
        }
    }
    else if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"--%@",newStr);
    if(connection==postAddrConn){
        addressId = [[newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""] integerValue];
        postStatus++;
        if(postStatus<2)
            return;
    }
    else if(connection==postContactConn){
        contactId = [[newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""] integerValue];
        postStatus++;
        if(postStatus<2)
            return;
    }
    
    if(postStatus==2){
        postStatus=0;
        NSString* url = [NSString stringWithFormat:@"http://%@PostUser?UserId=%@&Uname=%@&Dob=%@&GenderId=%@&AddressId=%d&ContactId=%d",[DataExchange getbaseUrl],[DataExchange getUserRoleId],[txtName.text stringByReplacingOccurrencesOfString:@" " withString:@"%20"],txtDob.text,([btnGender.titleLabel.text isEqualToString:@"M"]?@"1":@"2"),addressId,contactId];
        NSURL* myUrl = [[[NSURL alloc] initWithString:url] autorelease];
        NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
        [request setURL:myUrl];
        finalPostConn=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        if (!finalPostConn) {
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
        return;
    }
    else if(connection==finalPostConn){
        [DataExchange setAreaID:[NSString stringWithFormat:@"%d",areaId]];
        newStr = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
        if([newStr isEqualToString:[DataExchange getUserRoleId]]){
            UserDetail* temp = (UserDetail*)[[DataExchange getUserResult] objectAtIndex:0];
            temp.u_name = txtName.text;
        }
        return;
    }
    NSArray* response = [newStr JSONValue];
    if(connection==getUserConn){
        NSDictionary* dictTemp = (NSDictionary*)response;
        
        NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
        addressId = [[dictTemp objectForKey:@"AddressId"] integerValue];
        contactId =[[dictTemp objectForKey:@"ContactId"] integerValue];
        statusStr =[[dictTemp objectForKey:@"CurrentStatusId"] integerValue];
        NSString* url = [NSMutableString stringWithFormat:@"http://%@GetAddress?AddressID=%d&UserRoleID=%@",[DataExchange getbaseUrl],addressId,[DataExchange getUserRoleId]];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        getAddressConn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        
        url = [NSMutableString stringWithFormat:@"http://%@GetContactDetails?ContactID=%d&UserRoleID=%@",[DataExchange getbaseUrl],[[dictTemp objectForKey:@"ContactId"] integerValue],[DataExchange getUserRoleId]];
        [request setURL:[NSURL URLWithString:url]];
        [request setHTTPMethod:@"GET"];
        getContactDetailsConn = [[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
        
        if(![[dictTemp objectForKey:@"Dob"] isKindOfClass:[NSNull class]]){
            [lblDob setText:[ProfileSetingsView mfDateFromDotNetJSONString:[dictTemp objectForKey:@"Dob"]]];
            [txtDob setText:[ProfileSetingsView mfDateFromDotNetJSONString:[dictTemp objectForKey:@"Dob"]]];
        }
        if(![[dictTemp objectForKey:@"Uname"] isKindOfClass:[NSNull class]]){
            [lblName setText:[dictTemp objectForKey:@"Uname"]];
            [txtName setText:[dictTemp objectForKey:@"Uname"]];
        }
        
        NSInteger genderId = [([[dictTemp objectForKey:@"GenderId"] isKindOfClass:[NSNull class]]?@"1":[dictTemp objectForKey:@"GenderId"]) integerValue];
        [btnGender setTitle:(genderId==1?@"M":@"F") forState:UIControlStateNormal];
        
    }else if(connection==getContactDetailsConn){
        NSDictionary* dictTemp = (NSDictionary*)response;
        if(![[dictTemp objectForKey:@"Email"] isKindOfClass:[NSNull class]]){
            [lblEmail setText:[dictTemp objectForKey:@"Email"]];
            [txtEmail setText:[dictTemp objectForKey:@"Email"]];
        }
        if(![[dictTemp objectForKey:@"FixLine"] isKindOfClass:[NSNull class]]){
            [lblFixedLine setText:[dictTemp objectForKey:@"FixLine"]];
            [txtFixedLine setText:[dictTemp objectForKey:@"FixLine"]];
        }
        if(![[dictTemp objectForKey:@"FixLineExtn"] isKindOfClass:[NSNull class]]){
            [lblExtension setText:[dictTemp objectForKey:@"FixLineExtn"]];
            [txtExtension setText:[dictTemp objectForKey:@"FixLineExtn"]];
        }
        if(![[dictTemp objectForKey:@"Mobile"] isKindOfClass:[NSNull class]]){
            [lblMobile setText:[NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"Mobile"]]];
            [txtMobile setText:[NSString stringWithFormat:@"%@",[dictTemp objectForKey:@"Mobile"]]];
        }
        if(![[dictTemp objectForKey:@"Optemail"] isKindOfClass:[NSNull class]]){
            [lblOptEmail setText:[dictTemp objectForKey:@"Optemail"]];
            [txtOptEmail setText:[dictTemp objectForKey:@"Optemail"]];
        }
        if(![[dictTemp objectForKey:@"Optmobile"] isKindOfClass:[NSNull class]]){
            [lblOptMobile setText:[dictTemp objectForKey:@"Optmobile"]];
            [txtOptMobile setText:[dictTemp objectForKey:@"Optmobile"]];
        }
        if(![[dictTemp objectForKey:@"Skypeid"] isKindOfClass:[NSNull class]]){
            [lblSkypeId setText:[dictTemp objectForKey:@"Skypeid"]];
            [txtSkypeId setText:[dictTemp objectForKey:@"Skypeid"]];
        }
    }else if(connection==getAddressConn){
        NSDictionary* dictTemp = (NSDictionary*)response;
        if(![[dictTemp objectForKey:@"Address1"] isKindOfClass:[NSNull class]]){
            [lblAddress setText:[dictTemp objectForKey:@"Address1"]];
            [txtAddress setText:[dictTemp objectForKey:@"Address1"]];
        }
        if(![[dictTemp objectForKey:@"Address2"] isKindOfClass:[NSNull class]]){
            [lblAddress2 setText:[dictTemp objectForKey:@"Address2"]];
            [txtAddress2 setText:[dictTemp objectForKey:@"Address2"]];
        }
        areaId =[[dictTemp objectForKey:@"AreaId"] integerValue];
        self.zipcodeStr = [dictTemp objectForKey:@"Zipcode"];
        
        NSString* url = [NSMutableString stringWithFormat:@"%@GetCity_Area?AreaId=%d",[DataExchange getbaseUrl],areaId];
        [self.service getStringResponseInvocation:url Identifier:@"GetCity" delegate:self];
        
        url = [NSString stringWithFormat:@"%@GetCountry",[DataExchange getbaseUrl]];
        [self.service getStringResponseInvocation:url Identifier:@"GetCountry" delegate:self];
        pendingConnections=2;
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if(connection==finalPostConn){
        if (self.activityController) {
            [self.activityController dismissActivity];
            self.activityController = nil;
        }
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
	if(connection!=finalPostConn){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblAreas.hidden = true;
    tblGenders.hidden = true;
    tblStates.hidden = true;
    tblCity.hidden = true;
    tblCountry.hidden = true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    BOOL isNumeric=FALSE;
	if ([string length] == 0) 
	{
		isNumeric=TRUE;
	}
	else if(textField == txtMobile || textField== txtOptMobile || textField==txtExtension || textField==txtFixedLine)
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
        NSUInteger newLength = [textField.text length] + [string length] - range.length;
        if(textField == txtMobile && newLength > 10){
            isNumeric = NO;
        }
	}
    else {
        isNumeric = TRUE;
    }
    
	return isNumeric;
}

-(void) clickChangePassword:(id)sender{
    ChangePasswordController *addController = [[ChangePasswordController alloc] initWithNibName:@"ChangePasswordController" bundle:nil];
    addController.delegate = self;
    addController.btnToBeUsed = (UIButton*)sender;
    addController.isChangePswd = TRUE;
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease];
    self.popover.popoverContentSize = CGSizeMake(356, 253);
    [self.popover presentPopoverFromRect:CGRectMake(300.00,200.00, 25.00, 40.00) inView:self permittedArrowDirections:0 animated:YES];
    [addController release];
}

-(void) clickChangePin:(id)sender{
    ChangePasswordController *addController = [[ChangePasswordController alloc] initWithNibName:@"ChangePasswordController" bundle:nil];
    addController.delegate = self;
    addController.isChangePswd = false;
    addController.btnToBeUsed = (UIButton*)sender;
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(356, 253);
    [self.popover presentPopoverFromRect:CGRectMake(300.00,200.00, 25.00, 40.00) inView:self permittedArrowDirections:0 animated:YES];
    [addController release];
}

- (void) closePopUpPassword{
    [self.popover dismissPopoverAnimated:YES];
}

-(IBAction) clickSubmit:(id)sender{
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Posting ..."];
    
    NSString* dataToPost = [NSString stringWithFormat:@"{\"_add\":{\"Address1\":\"%@\",\"Address2\":\"%@\",\"AreaId\":%d,\"Zipcode\":\"%@\",\"AddressId\":%d},\"UserRoleID\":%@}",txtAddress.text,txtAddress2.text,areaId,self.zipcodeStr,addressId,[DataExchange getUserRoleId]];
    NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostAddress",[DataExchange getbaseUrl]]] autorelease];
    NSMutableURLRequest* request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    postAddrConn=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!postAddrConn) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    
    dataToPost = [NSString stringWithFormat:@"{\"cd\":{\"Mobile\":\"%@\",\"Optmobile\":\"%@\",\"FixLine\":\"%@\",\"FixLineExtn\":\"%@\",\"Skypeid\":\"%@\",\"Email\":\"%@\",\"Optemail\":\"%@\",\"ContactId\":%d},\"UserRoleID\":%@}",txtMobile.text,@"",txtFixedLine.text,@"",txtSkypeId.text,txtEmail.text,@"",contactId,[DataExchange getUserRoleId]];
    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostContactDetails",[DataExchange getbaseUrl]]] autorelease];
    request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    //to satisfy condition
    postContactConn=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!postContactConn) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    
    dataToPost = [NSString stringWithFormat:@"{\"DisplayLabel\":{\"UserDisplayId\":%d,\"Line1\":\"%@\",\"Line2\":\"%@\",\"Line3\":\"%@\",\"Line4\":\"%@\"},\"sub_tenant_id\":\"%d\",\"UserRoleID\":%@}",displaySettingsId,[self.arrayDisplaySettings objectAtIndex:0],[self.arrayDisplaySettings objectAtIndex:1],[self.arrayDisplaySettings objectAtIndex:2],[self.arrayDisplaySettings objectAtIndex:3],[DataExchange getSubTenantId],[DataExchange getUserRoleId]];
    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostDisplayLabel",[DataExchange getbaseUrl]]] autorelease];
    request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
     NSURLConnection* connection=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!connection) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    
    dataToPost = [NSString stringWithFormat:@"{\"PrintLabel\":{\"UserPrintId\":%d,\"Line1\":\"%@\",\"Line2\":\"%@\",\"Line3\":\"%@\",\"Line4\":\"%@\"},\"sub_tenant_id\":\"%d\",\"UserRoleID\":%@}",printSettingsId,[self.arrayPrintSettings objectAtIndex:0],[self.arrayPrintSettings objectAtIndex:1],[self.arrayPrintSettings objectAtIndex:2],[self.arrayPrintSettings objectAtIndex:3],[DataExchange getSubTenantId],[DataExchange getUserRoleId]];
    myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostPrintLabel",[DataExchange getbaseUrl]]] autorelease];
    request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:myUrl];
    [request setHTTPMethod:@"POST"];
    [request setAllHTTPHeaderFields:[[[NSDictionary alloc] initWithObjects:[[[NSArray alloc] initWithObjects:@"application/json",@"utf-8",[DataExchange getDomainUrl],[NSString stringWithFormat:@"%d",dataToPost.length], nil] autorelease] forKeys:[[[NSArray alloc] initWithObjects:@"Content-Type",@"charset",@"Host",@"Content-Length", nil]autorelease]]autorelease]];
    [request setHTTPBody:[NSData dataWithBytes:[dataToPost UTF8String] length:[dataToPost lengthOfBytesUsingEncoding:NSUTF8StringEncoding]]];
    NSURLConnection* connection2=[[[NSURLConnection alloc] initWithRequest:request delegate:self] autorelease];
    if (!connection2) {
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"No Internet Connection" message:@"Please Try Again Later" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    
    [DataExchange setDocDisplayData:self.arrayDisplaySettings];
}

- (void) closePopUpDate:(NSString*)dt{
    
    [self.popover dismissPopoverAnimated:YES];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat: @"dd-MMM-yyyy"];    
    NSDate *dateFromString = [dateFormatter dateFromString:dt];
    
    if([self daysBetweenDate:dateFromString andDate:[NSDate date]]<0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Date-of-birth is not valid. Please try again! " delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    
    if(dt != nil){
        self.txtDob.text = dt;
    }
}

-(NSInteger) daysBetweenDate:(NSDate *)firstDate andDate:(NSDate *)secondDate{
    unsigned int flags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    NSDateComponents* components = [calendar components:flags fromDate:firstDate];
    NSDate* date1Only = [calendar dateFromComponents:components];
    
    NSDateComponents* components2 = [calendar components:flags fromDate:secondDate];
    NSDate* date2Only = [calendar dateFromComponents:components2];
    
    NSDateComponents *componentsFinal = [calendar components: NSDayCalendarUnit fromDate:date1Only toDate:date2Only options: 0];
    NSInteger days = [componentsFinal day];
    return days;
}

-(IBAction) clickFromDOB:(id)sender{
    
    //[self.txtDob resignFirstResponder];
    
    UITextField *theSender = sender;
    
    STPNDatePickerViewController *addController = [[STPNDatePickerViewController alloc] initWithNibName:@"STPNDatePickerViewController" bundle:nil];
    
    addController.delegate = self;
    
    self.popover = [[[UIPopoverController alloc] initWithContentViewController:addController] autorelease]; 
    self.popover.popoverContentSize = CGSizeMake(300, 259);
    
    [self.popover presentPopoverFromRect:CGRectMake(0.00,00.00, 25.00, 40.00) inView:theSender permittedArrowDirections:UIPopoverArrowDirectionLeft animated:YES];
    [addController release];
}

-(IBAction) clickEdit{
    self.staticOverlayView.hidden = true;
}

+ (NSString *)mfDateFromDotNetJSONString:(NSString *)string{
    static NSRegularExpression *dateRegEx = nil;
    static dispatch_once_t onceToken;
    NSDateFormatter *df = [[[NSDateFormatter alloc] init] autorelease];
    [df setDateFormat:@"dd-MMM-yyyy"];
    
    dispatch_once(&onceToken, ^{
        dateRegEx = [[NSRegularExpression alloc] initWithPattern:@"^\\/date\\((-?\\d++)(?:([+-])(\\d{2})(\\d{2}))?\\)\\/$" options:NSRegularExpressionCaseInsensitive error:nil];
    });
    NSTextCheckingResult *regexResult = [dateRegEx firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    if (regexResult) {
        // milliseconds
        NSTimeInterval seconds = [[string substringWithRange:[regexResult rangeAtIndex:1]] doubleValue] / 1000.0;
        // timezone offset
        if ([regexResult rangeAtIndex:2].location != NSNotFound) {
            NSString *sign = [string substringWithRange:[regexResult rangeAtIndex:2]];
            // hours
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:3]]] doubleValue] * 60.0 * 60.0;
            // minutes
            seconds += [[NSString stringWithFormat:@"%@%@", sign, [string substringWithRange:[regexResult rangeAtIndex:4]]] doubleValue] * 60.0;
        }
        return [df stringFromDate:[NSDate dateWithTimeIntervalSince1970:seconds]];
    }
    return nil;
}

@end

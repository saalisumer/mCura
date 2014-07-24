//
//  TemplatesView.m
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TemplatesView.h"
#import "DataExchange.h"
#import "Schedule.h"
#import "Dosage.h"
#import "DosageFrm.h"
#import "Instruction.h"
#import "Pharmacy.h"
#import "GetDosageInvocation.h"
#import "GetDosageFrmInvocation.h"
#import "GetFollowUpInvocation.h"
#import "GetGenericInvocation.h"
#import "GetInstructionInvocation.h"
#import "GetStringInvocation.h"
#import <QuartzCore/QuartzCore.h>
#import "DrugViewController.h"
#import "mCuraSqlite.h"
#import "PriceObject.h"
#define min(X,Y) (X<Y?X:Y)
static int Gen_Brand=0;

@interface TemplatesView (private)<GetDosageInvocationDelegate, GetGenericInvocationDelegate, GetFollowUpInvocationDelegate, GetDosageFrmInvocationDelegate, GetInstructionInvocationDelegate,GetBrandInvocationDelegate,GetStringInvocationDelegate,GetTemplateInvocationDelegate,GetBrandIDDelegate>
@end

@implementation TemplatesView
@synthesize service,activityController,mParentController;
@synthesize tblBrand,tblDosage,tblGeneric,tblFollowUp,tblDosageFrm,tblInstruction;
@synthesize btnBrand,btnGeneric,arrDrugIndices,brandDtlsForDrugView,uniquebrandDtls,TempBrandURL;
@synthesize genericDtls, dosageDtls, brandDtls, dosageFrmDtls, instructionDtls, followUpDtls;

-(id)initWithParent:(UserAccountViewController *)parent{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"TemplatesView" owner: self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    childNavBar.layer.cornerRadius = 5.0;
    currPharmacyOrder = [[PharmacyOrder alloc] init];
    
    self.service = [[[_GMDocService alloc] init] autorelease];
    self.mParentController = parent;
    self.activityController = [ISActivityOverlayController presentActivityOverViewController:parent withLabel:@"Loading..."];
    [self.service getInstructionInvocation:[DataExchange getUserRoleId] delegate:self];
    [self.service getFollowUpInvocation:[DataExchange getUserRoleId] delegate:self];
    NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brands",[DataExchange getbaseUrl]];
    [self.service getStringResponseInvocation:url Identifier:@"GetBrands" delegate:self];
    
    currPharmacyOrderArray = [[NSMutableArray alloc] init];
    self.tblBrand.layer.cornerRadius = 10;
    self.tblDosage.layer.cornerRadius = 10;
    self.tblDosageFrm.layer.cornerRadius = 10;
    self.tblFollowUp.layer.cornerRadius = 10;
    self.tblGeneric.layer.cornerRadius = 10;
    self.tblInstruction.layer.cornerRadius = 10;
    return self;
}

#pragma mark textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==txtBrand){
        if ([txtGenerics.text isEqualToString:@""]) {
            self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
            
        }
        else{
            
            self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
            
        }
        
        
        [self.tblBrand reloadData];
        self.tblBrand.hidden = FALSE;
    }
    else if(textField==txtGenerics){
        self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidGenericRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
        [self.tblGeneric reloadData];
        self.tblGeneric.hidden = FALSE;
    }
	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField==txtGenerics){
        txtBrand.text = @"";
        Gen_Brand=0;
    }
    if(textField==txtBrand && [txtGenerics.text length]>0){
        
        Gen_Brand=0;
        self.UniquebrandDtls=nil;
    }
    return YES;
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if(tableView == self.tblGeneric)
        return self.genericDtls.count;
    else if(tableView == self.tblBrand)
        return self.brandDtls.count;
    else if(tableView == self.tblDosage)
        return self.dosageDtls.count;
    else if(tableView == self.tblDosageFrm)
        return self.dosageFrmDtls.count;
    else if(tableView == self.tblInstruction)
        return self.instructionDtls.count;
    else if(tableView == self.tblFollowUp)
        return self.followUpDtls.count;
    else
        return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    if(tableView == self.tblGeneric){
        UITableViewCell *cell = [self.tblGeneric dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        Generic *nat = [self.genericDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.Generic;
        
        return cell;
    }
    else if(tableView == self.tblBrand){
        UITableViewCell *cell = [self.tblBrand dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Brand *nat = [self.brandDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.BrandName;
        
        return cell;
    }
    else if(tableView == self.tblDosage){
        UITableViewCell *cell = [self.tblDosage dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Dosage *nat = [self.dosageDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.DosageProperty;
        
        return cell;
    }
    else if(tableView == self.tblDosageFrm){
        UITableViewCell *cell = [self.tblDosageFrm dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        DosageFrm *nat = [self.dosageFrmDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.DosageFormProperty;
        
        return cell;
    }
    else if(tableView == self.tblInstruction){
        UITableViewCell *cell = [self.tblInstruction dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        Instruction *nat = [self.instructionDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = nat.Instruction;
        
        return cell;
    }
    else if(tableView == self.tblFollowUp){
        UITableViewCell *cell = [self.tblFollowUp dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        FollowUp *nat = [self.followUpDtls objectAtIndex:indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"%d %@",[nat.Durationno integerValue],nat.Durationunits];
        return cell;
    }
    else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(tableView == self.tblGeneric){
        currentGeneric = [self.genericDtls objectAtIndex:indexPath.row];
        currentGenericsIndex = indexPath.row+1;
        currentBrandIdIndex = 0;
        if(!self.activityController)
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Loading..."];
        [self.btnGeneric setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [txtGenerics setText:cell.textLabel.text];
        [txtGenerics resignFirstResponder];
        [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
        [self.btnBrand setTitle:@"--Select--" forState:UIControlStateNormal];
        txtBrand.text = @"";
        currentBrand=nil;
        Gen_Brand=0;
        self.tblGeneric.hidden = YES;
    }
    else if(tableView == self.tblBrand){
        if(!self.activityController){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Loading..."];
        }
        if ([txtGenerics.text isEqualToString:@""]) {
            Gen_Brand=GenericfromBrand;
            currentGenericsIndex =1;
             uniquebrandDtls= [[NSMutableArray alloc] init];
            [uniquebrandDtls addObject:(Brand*)[self.brandDtls objectAtIndex:indexPath.row]];
        }
        else if([txtGenerics.text length]>0){
            Gen_Brand=0;
        }

          [txtBrand resignFirstResponder];
        currentBrand = (Brand*)[self.brandDtls objectAtIndex:indexPath.row];
        currentBrandIdIndex = indexPath.row+1;
        NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],[[(Brand*)[self.brandDtls objectAtIndex:indexPath.row] BrandId] integerValue]];
        [self.service getBrandsIDInvocation:[DataExchange getUserRoleId] BrandId:[NSString stringWithFormat:@"%d",[[(Brand*)[self.brandDtls objectAtIndex:indexPath.row] BrandId] integerValue]] delegate:self];
         TempBrandURL=[[NSString alloc]initWithString:url];
        NSLog(@"BRand_rugs_URL is:-%@",url);
        if (Gen_Brand==GenericfromBrand&& [txtGenerics.text isEqualToString:@""]) {
            
            //[self.service getStringResponseInvocation:url Identifier:@"Pricing" delegate:self];
            
        }
        else{
            
            [self.service getStringResponseInvocation:url Identifier:@"GetDosageData" delegate:self];
        }

        [self.btnBrand setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [txtBrand setText:cell.textLabel.text];
        self.tblBrand.hidden = YES;
    }
    else if(tableView == self.tblDosage){
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage = [(Dosage*)[self.dosageDtls objectAtIndex:indexPath.row] DosageProperty];
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_id = [(Dosage*)[self.dosageDtls objectAtIndex:indexPath.row] DosageId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.instruction = cell.textLabel.text;
                break;
            }
        }
        self.tblDosage.hidden = YES;
    }
    else if(tableView == self.tblDosageFrm){
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_form = [(DosageFrm*)[self.dosageFrmDtls objectAtIndex:indexPath.row] DosageFormProperty];
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_form_id = [(DosageFrm*)[self.dosageFrmDtls objectAtIndex:indexPath.row] DosageFormId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.instruction = cell.textLabel.text;
                break;
            }
        }
        self.tblDosageFrm.hidden = YES;
    }
    else if(tableView == self.tblInstruction){
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).dosage_ins_id = [(Instruction*)[self.instructionDtls objectAtIndex:indexPath.row] DosageInsId];
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).instruction = [(Instruction*)[self.instructionDtls objectAtIndex:indexPath.row] Instruction];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                PharmacyOrder* currentOrder = (PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:btn.tag/10];
                currentOrder.instruction = cell.textLabel.text;
                break;
            }
        }
        self.tblInstruction.hidden = YES;
    }
    else if(tableView == self.tblFollowUp){
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).durationno = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] Durationno];
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).durationunits = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] Durationunits];
        ((PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:currentBtnPressedTag/10]).followup_id = [(FollowUp*)[self.followUpDtls objectAtIndex:indexPath.row] FollowupId];
        for (UIButton*btn in [pharmacyOrderScrollView subviews]) {
            if(btn.tag==currentBtnPressedTag){
                [btn setTitle:cell.textLabel.text forState:UIControlStateNormal];
                break;
            }
        }
        self.tblFollowUp.hidden = YES;
    }
}

-(void)setBrand:(Brand*)brand{
    currentBrand = brand;
    self.brandDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidBrandRecords:@""]];
    for (int i=0; i<self.brandDtls.count; i++) {
        if([[(Brand*)[self.brandDtls objectAtIndex:i] BrandId] integerValue]==brand.BrandId.integerValue){
            currentBrandIdIndex = i+1;
            break;
        }
    }
    NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],[[(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandId] integerValue]];
    [self.service getStringResponseInvocation:url Identifier:@"GetDosageData" delegate:self];
    [txtBrand setText:[(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandName]];
    self.tblBrand.hidden = YES;
}

-(void) setGeneric:(Generic*)generic{
    currentGeneric = generic;
    self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidGenericRecords:@""]];
    for (int i=0; i<self.genericDtls.count; i++) {
        if([[(Generic*)[self.genericDtls objectAtIndex:i] GenericId] integerValue]==generic.GenericId.integerValue){
            currentGenericsIndex = i+1;
            break;
        }
    }
    [txtGenerics setText:[(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] Generic]];
    self.tblGeneric.hidden = YES;
    Gen_Brand=0;
}

-(IBAction) clickGenericBtn:(id)sender{
    self.tblGeneric.hidden = NO;
}

-(IBAction) clickBrandBtn:(id)sender{
    self.tblBrand.hidden = NO;
}

-(void) clickFollowupBtn:(id)sender{
    self.tblFollowUp.hidden = NO;
}

-(void) clickDosageBtn:(id)sender{
    self.tblDosage.hidden = NO;
}

-(void) clickDosageFormBtn:(id)sender{
    self.tblDosageFrm.hidden = NO;
}

-(void) clickInstructionBtn:(id)sender{
    self.tblInstruction.hidden = NO;
}

#pragma mark Invocations

-(void) getDosageInvocationDidFinish:(GetDosageInvocation*)invocation
                         withDosages:(NSArray*)dosages
                           withError:(NSError*)error{
    if(!error){
        if([dosages count] > 0){
            self.dosageDtls = [[NSMutableArray alloc] initWithArray:dosages];
            [self.tblDosage reloadData];
            tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,200));
        }
    }
}

-(void) getGenericInvocationDidFinish:(GetGenericInvocation*)invocation
                      withInvocations:(NSArray*)invocations
                            withError:(NSError*)error{
    if(!error){
        if([invocations count] > 0){
            self.genericDtls = [[NSMutableArray alloc] initWithArray:invocations];
            [self.tblGeneric reloadData];
            tblGeneric.frame = CGRectMake(tblGeneric.frame.origin.x, tblGeneric.frame.origin.y, tblGeneric.frame.size.width, min(20+44*genericDtls.count,260));
        }
    }
}

-(void) getDosageFrmInvocationDidFinish:(GetDosageFrmInvocation*)invocation
                            withDosages:(NSArray*)dosages
                              withError:(NSError*)error{
    if(!error){
        if([dosages count] > 0){
            self.dosageFrmDtls = [[NSMutableArray alloc] initWithArray:dosages];
            [self.tblDosageFrm reloadData];
            tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,200));
        }
    }
}

-(void) getFollowUpInvocationDidFinish:(GetFollowUpInvocation*)invocation
                           withFollows:(NSArray*)follows
                             withError:(NSError*)error{
    if(!error){
        if([follows count] > 0){
            self.followUpDtls = [[NSMutableArray alloc] initWithArray:follows];
            [self.tblFollowUp reloadData];
            self.tblFollowUp.frame = CGRectMake(tblFollowUp.frame.origin.x, tblFollowUp.frame.origin.y, tblFollowUp.frame.size.width, min(20+44*followUpDtls.count,200));
        }
    }
}

-(void) getInstructionInvocationDidFinish:(GetInstructionInvocation*)invocation
                          withInvocations:(NSArray*)invocations
                                withError:(NSError*)error{
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
    if(!error){
        if([invocations count] > 0){
            self.instructionDtls = [[NSMutableArray alloc] initWithArray:invocations];
            [self.tblInstruction reloadData];
            tblInstruction.frame = CGRectMake(tblInstruction.frame.origin.x, tblInstruction.frame.origin.y, tblInstruction.frame.size.width, min(20+44*instructionDtls.count,200));
        }
    }
}

-(void) GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                  withResponseString:(NSString *)responseString 
                      withIdentifier:(NSString *)identifier 
                           withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetBrands"]){
            self.brandDtls = [[NSMutableArray alloc] init];
            NSDictionary* dictTemp;
            for (int i=0; i<response.count; i++) {
                dictTemp = [response objectAtIndex:i];
                Brand* brandtemp = [[Brand alloc] init];
                brandtemp.BrandName = [dictTemp objectForKey:@"Name"];
                brandtemp.BrandId = [dictTemp objectForKey:@"Id"];
                [self.brandDtls addObject:brandtemp];
            }
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<self.brandDtls.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[self.brandDtls objectAtIndex:i] ForGenericId:0];
            }
            [self.tblBrand reloadData];
            tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
        }else if([identifier isEqualToString:@"GetDosageData"]){
            self.dosageDtls = [[NSMutableArray alloc] init];
            self.dosageFrmDtls = [[NSMutableArray alloc] init];
            if(responseString.length<2){
                [self.tblDosage reloadData];
                tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                [self.tblDosageFrm reloadData];
                tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
                return;
            }
            NSDictionary* dictTemp = [responseString JSONValue];
            NSArray* pricesArr = [dictTemp objectForKey:@"Pricing"];
            for (int i=0; i<pricesArr.count; i++){
                NSDictionary* priceDict = [pricesArr objectAtIndex:i];
                DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
                dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
                dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
                [self.dosageFrmDtls addObject:dosagefrmTemp];
                
                Dosage* dosageTemp = [[Dosage alloc] init];
                dosageTemp.DosageId = [NSNumber numberWithInt:1];
                dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
                [self.dosageDtls addObject:dosageTemp];
            }
            [self.tblDosage reloadData];
            tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
            [self.tblDosageFrm reloadData];
            tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
        }
        
        else if([identifier isEqualToString:@"Pricing"]){
            
            self.dosageDtls = [[NSMutableArray alloc] init];
            self.dosageFrmDtls = [[NSMutableArray alloc] init];
            if(responseString.length<2){
                NSDictionary* dictTemp = [responseString JSONValue];
                NSDictionary* priceDict = [dictTemp objectForKey:@"Pricing"];
                DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
                dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
                dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
                [self.dosageFrmDtls addObject:dosagefrmTemp];
                
                Dosage* dosageTemp = [[Dosage alloc] init];
                dosageTemp.DosageId = [NSNumber numberWithInt:1];
                dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
                [self.dosageDtls addObject:dosageTemp];
                
                
                [self.tblDosage reloadData];
                tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                [self.tblDosageFrm reloadData];
                tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
                //return;
            }
            else{
                NSDictionary* dictTemp = [responseString JSONValue];
                NSArray* pricesArr = [dictTemp objectForKey:@"Pricing"];
                for (int i=0; i<pricesArr.count; i++){
                    NSDictionary* priceDict = [pricesArr objectAtIndex:i];
                    DosageFrm* dosagefrmTemp = [[DosageFrm alloc] init];
                    dosagefrmTemp.DosageFormId = [NSNumber numberWithInt:1];
                    dosagefrmTemp.DosageFormProperty = [priceDict objectForKey:@"DosageForm"];
                    [self.dosageFrmDtls addObject:dosagefrmTemp];
                    
                    Dosage* dosageTemp = [[Dosage alloc] init];
                    dosageTemp.DosageId = [NSNumber numberWithInt:1];
                    dosageTemp.DosageProperty = [priceDict objectForKey:@"Strength"];
                    [self.dosageDtls addObject:dosageTemp];
                }
                [self.tblDosage reloadData];
                tblDosage.frame = CGRectMake(tblDosage.frame.origin.x, tblDosage.frame.origin.y, tblDosage.frame.size.width, min(20+44*dosageDtls.count,260));
                [self.tblDosageFrm reloadData];
                tblDosageFrm.frame = CGRectMake(tblDosageFrm.frame.origin.x, tblDosageFrm.frame.origin.y, tblDosageFrm.frame.size.width, min(20+44*dosageFrmDtls.count,260));
            }
        }
    }
}

-(void) getBrandInvocationDidFinish:(GetBrandInvocation*)invocation
                         withBrands:(NSArray*)brands
                          withError:(NSError*)error{
    if (self.activityController) {
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
    if(!error){
        if([brands count] > 0){
            self.brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            self.brandDtlsForDrugView = [[NSMutableArray alloc] initWithArray:brands];
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<brands.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:[currentGeneric.GenericId integerValue]];
            }
            [self.tblBrand reloadData];
            // tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
            
        }
        else{
            if (Gen_Brand==GenericfromBrand) {
            }
            else{
                proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find brand for this generic!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
                [alert show];
                [alert release];
            }
            
        }
    }
}

-(void) getBrandIDDidFinish:(GetBrandIDInvocation*)invocation withBrands:(NSArray*)brands withError:(NSError*)error{
    
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
    if(!error){
        if([brands count] > 0){
            // [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<brands.count; i++) {
                // [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:0];
            }
            // self.brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            self.brandDtlsForDrugView = [[[NSMutableArray alloc] initWithArray:brands] retain];
            // [self.tblBrand reloadData];
            // tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
            if ([txtGenerics.text isEqualToString:@""]) {
                // Gen_Brand=GenericfromBrand;
                // NSArray* temp = [(Brand*)[brands objectAtIndex:0] arrayGeneric];
                 [self.service getStringResponseInvocation:TempBrandURL Identifier:@"Pricing" delegate:self];
                for (int i=0; i<[[(Brand*)[brands objectAtIndex:0] arrayGeneric] count]; i++){
                    self.genericDtls =nil;
                    //  NSLog(@"%@",[[(PriceObject*)[(Brand*)[brands objectAtIndex:0] arrayGeneric]objectAtIndex:i]PGenericName]);
                    
                    strgeneric=[NSString stringWithString:[[(PriceObject*)[(Brand*)[brands objectAtIndex:0] arrayGeneric]objectAtIndex:i]PGenericName]];
                }
                self.genericDtls = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnSelectedGenericID:strgeneric]];
                currentGeneric = [self.genericDtls objectAtIndex:0];
                if(!self.activityController){
                    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Loading..."];
                }
                [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
                [txtGenerics setText:[(Generic*)[self.genericDtls objectAtIndex:0] Generic]];
                tblGeneric.hidden = YES;
                
                
                //[self reloadViews];
            }
            
        }
        else{
            
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find this Brand Details!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
    
    
    
}

#pragma mark others

-(void)addFieldBtnPressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    CGRect rectFrame;
    currentBtnPressedTag = btn.tag;
    switch (btn.tag%10) {
        case 1://dosage btn pressed
            rectFrame = self.tblDosage.frame;
            rectFrame.origin.y = 327 + 3.9 * btn.tag;
            self.tblDosage.frame = rectFrame;
            self.tblDosage.hidden = false;
            break;
        case 2://dosage form btn pressed
            rectFrame = self.tblDosageFrm.frame;
            rectFrame.origin.y = 327 + 3.9 * btn.tag;
            self.tblDosageFrm.frame = rectFrame;
            self.tblDosageFrm.hidden = false;
            break;
        case 3://instr btn pressed
            rectFrame = self.tblInstruction.frame;
            rectFrame.origin.y = 327 + 3.9 * btn.tag;
            self.tblInstruction.frame = rectFrame;
            self.tblInstruction.hidden = false;
            break;
        case 4://duration btn pressed
            rectFrame = self.tblFollowUp.frame;
            rectFrame.origin.y = 327 + 3.9 * btn.tag;
            self.tblFollowUp.frame = rectFrame;
            self.tblFollowUp.hidden = false;
            break;
        default:
            break;
    }
}

-(IBAction)openDrugsIndex:(id)sender{
    NSInteger index = [sender tag]-101;
    DrugViewController* controller = [[DrugViewController alloc] initWithNibName:@"DrugViewController" bundle:nil];
    controller.arrBrands = self.brandDtlsForDrugView;
    controller.templateParentView = self;
    controller.selectedGeneric= currentGeneric;
    controller.isparentView=YES;
    if(index==1)
        controller.selectedBrand = currentBrand;
    [self.mParentController presentModalViewController:controller animated:YES];
    [controller release];
}

-(IBAction)addBtnPressed{
    if(currentGenericsIndex==0 || currentBrandIdIndex==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please select all options before adding!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
    else{
        PharmacyOrder* currentPharmacyOrder = [[PharmacyOrder alloc] init];
        if (Gen_Brand==GenericfromBrand) {
            currentPharmacyOrder.Generic = [(Generic*)[self.genericDtls objectAtIndex:0] Generic];
            currentPharmacyOrder.generic_id = [(Generic*)[self.genericDtls objectAtIndex:0] GenericId];
            
            currentPharmacyOrder.brand_name = [(Brand*)[self.uniquebrandDtls objectAtIndex:0] BrandName];
            currentPharmacyOrder.brand_id = [(Brand*)[self.uniquebrandDtls objectAtIndex:0] BrandId];
             self.UniquebrandDtls=nil;
        }
        else{
            currentPharmacyOrder.Generic = [(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] Generic];
            currentPharmacyOrder.generic_id = [(Generic*)[self.genericDtls objectAtIndex:currentGenericsIndex-1] GenericId];
            
            currentPharmacyOrder.brand_name = [(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandName];
            currentPharmacyOrder.brand_id = [(Brand*)[self.brandDtls objectAtIndex:currentBrandIdIndex-1] BrandId];
        }
       
        currentPharmacyOrder.dosage = nil;
        currentPharmacyOrder.dosage_id = nil;
        currentPharmacyOrder.followup_id = nil;
        currentPharmacyOrder.instruction = nil;
        currentPharmacyOrder.dosage_form = nil;
        currentPharmacyOrder.dosage_form_id = nil;
        currentPharmacyOrder.durationunits = nil;
        [currPharmacyOrderArray addObject:currentPharmacyOrder];
        [self addPharmacyOrder];
        if(currPharmacyOrderArray.count<7){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            slidingView.frame = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y + 39, slidingView.frame.size.width, slidingView.frame.size.height);
            [UIView commitAnimations];
        }
    }
}

-(void)addPharmacyOrder{
    [pharmacyOrderScrollView setContentSize:CGSizeMake(704,currPharmacyOrderArray.count*39)];
    for(UIView *v in [pharmacyOrderScrollView subviews])
    {
        [v removeFromSuperview];
        v = nil;
    }
    
    for (int i = 0; i<currPharmacyOrderArray.count; i++) {
        UIButton* btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 10+39*i, 20, 20);
		btn.tag = 1000 + i;
        [btn setImage:[UIImage imageNamed:@"cross.png"] forState:UIControlStateNormal];
        [btn setTitle:[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] Generic] forState:UIControlStateNormal];        
		[btn addTarget:self action:@selector(deleteRecordBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn];
        UILabel* label1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 1+39*i, 117, 37)];
        label1.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] Generic];
        label1.textAlignment = UITextAlignmentCenter;
        [pharmacyOrderScrollView addSubview:label1];
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(117, 1+39*i, 117, 37)];
        label2.text = [(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] brand_name];
        label2.textAlignment = UITextAlignmentCenter;
        [pharmacyOrderScrollView addSubview:label2];
        [label1 setBackgroundColor:[UIColor clearColor]];
        [label2 setBackgroundColor:[UIColor clearColor]];
        [label1 release];
        [label2 release];
        [pharmacyOrderScrollView addSubview:btn];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 39*(i+1), 1024, 1)];
        [line setBackgroundColor:[UIColor whiteColor]];
        [pharmacyOrderScrollView addSubview:line];
        [line release];
        
        //--------dosage frm btn
        UIButton* btn1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn1.frame = CGRectMake(5+117*2, 5+39*i, 107, 30);
		btn1.tag = 10*i+2;
        [btn1 setTitle:([(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage_form]!=nil?[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage_form]:@"--Select--") forState:UIControlStateNormal];
		[btn1 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn1];
        //--------dosage btn
        UIButton* btn2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn2.frame = CGRectMake(5+117*3, 5+39*i, 107, 30);
		btn2.tag = 10*i+1;
        [btn2 setTitle:([(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage]!=nil?[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] dosage]:@"--Select--") forState:UIControlStateNormal];
		[btn2 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn2];
        //--------instruction btn
        UIButton* btn3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn3.frame = CGRectMake(5+117*4, 5+39*i, 107, 30);
		btn3.tag = 10*i+3;
        [btn3 setTitle:([(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] instruction]!=nil?[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] instruction]:@"--Select--") forState:UIControlStateNormal];        
		[btn3 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn3];
        //--------follow up btn
        UIButton* btn4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn4.frame = CGRectMake(5+117*5, 5+39*i, 107, 30);
		btn4.tag = 10*i+4;
        NSString* str = [NSString stringWithFormat:@"%d %@",[[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationno] integerValue],[(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]];
        [btn4 setTitle:([(PharmacyOrder*)[currPharmacyOrderArray objectAtIndex:i] durationunits]!=nil?str:@"--Select--") forState:UIControlStateNormal];
		[btn4 addTarget:self action:@selector(addFieldBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [pharmacyOrderScrollView addSubview:btn4];
    }
}

-(void)deleteRecordBtnPressed:(id)sender{
    UIButton* btn = (UIButton*)sender;
    currentOrderDeleteTag = btn.tag - 1000;
    deleteAlertView = [[proAlertView alloc] initWithTitle:@"Delete?" message:@"Are you sure you want to delete this order?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [deleteAlertView setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [deleteAlertView show];
}

-(IBAction)submitBtnPressed{
    if(templateName.text.length==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Warning!" message:@"Please enter a Template name before proceeding" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else if(currPharmacyOrderArray.count==0){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Warning!" message:@"Please add a template before proceeding" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    else for(int i=0;i<currPharmacyOrderArray.count;i++){
        currPharmacyOrder = [currPharmacyOrderArray objectAtIndex:i];
        if([currPharmacyOrder.dosage_form_id integerValue]==0 || [currPharmacyOrder.dosage_ins_id integerValue]==0 || [currPharmacyOrder.dosage_id integerValue]==0 || [currPharmacyOrder.followup_id integerValue]==0 || [currPharmacyOrder.brand_id integerValue]==0 || [currPharmacyOrder.generic_id integerValue]==0){
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Please select all values before proceeding" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
            return;
        }
    }
    proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Submit?" message:@"Are you sure you want to submit this template?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
    [alert show];
    [alert release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView==deleteAlertView){
        [currPharmacyOrderArray removeObjectAtIndex:currentOrderDeleteTag];
        if(currPharmacyOrderArray.count<7){
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.5];
            slidingView.frame = CGRectMake(slidingView.frame.origin.x, slidingView.frame.origin.y - 39, slidingView.frame.size.width, slidingView.frame.size.height);
            [UIView commitAnimations];
        }
        [self addPharmacyOrder];
        return;
    }
    if(buttonIndex==1){
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self.mParentController withLabel:@"Loading ..."];
        
        NSString* dataToPost = [NSString stringWithFormat:@"{\"medicine\":["];
        for (int i=0; i<currPharmacyOrderArray.count; i++) {
            currPharmacyOrder = [currPharmacyOrderArray objectAtIndex:i];
            dataToPost = [dataToPost stringByAppendingFormat:@"{\"DosageFormId\":%d,\"DosageInsId\":%d,\"DosageId\":%d,\"Followupid\":%d,\"BrandID\":%d,\"GenericName\":\"%@\",\"BrandName\":\"%@\",\"DosageName\":\"%@\",\"DosageFromName\":\"%@\",\"GenericsID\":%d},",[currPharmacyOrder.dosage_form_id integerValue],[currPharmacyOrder.dosage_ins_id integerValue],[currPharmacyOrder.dosage_id integerValue],[currPharmacyOrder.followup_id integerValue],[currPharmacyOrder.brand_id integerValue],currPharmacyOrder.Generic,currPharmacyOrder.brand_name,currPharmacyOrder.dosage,currPharmacyOrder.dosage_form,[currPharmacyOrder.generic_id integerValue]];
        }
        dataToPost = [dataToPost substringToIndex:(dataToPost.length-1)];
        dataToPost = [dataToPost stringByAppendingFormat:@"],\"TemplateName\":\"%@\",\"UserRoleID\":%@}",templateName.text,[DataExchange getUserRoleId]];
        
        NSURL* myUrl = [[[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://%@PostTemplates",[DataExchange getbaseUrl]]] autorelease];
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

#pragma mark connection delegate

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    if([newStr caseInsensitiveCompare:@"true"]==NSOrderedSame){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"" message:@"Template posted successfully!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Something Went Wrong" message:@"Please Try Again" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil];
    [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
	[alert show];
	[alert release];
	return;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblBrand.hidden = true;
    tblDosage.hidden = true;
    tblDosageFrm.hidden = true;
    tblFollowUp.hidden = true;
    tblGeneric.hidden = true;
    tblInstruction.hidden = true;
    [templateName resignFirstResponder];
}

@end

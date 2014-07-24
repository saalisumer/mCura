//
//  DrugViewController.m
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "DrugViewController.h"
#import "DrugIndex.h"
#import "SubTenant.h"
#import "PriceObject.h"
#import "mCuraSqlite.h"
#import "proAlertView.h"
#import "DosageTableController.h"
#import "OtherDrugTableController.h"
#import "Brand+Parse.h"

#define min(X,Y) (X<Y?X:Y)
static int Gen_Brand=0;

@implementation DrugViewController

@synthesize genericId,brandId,service,activityController,arrDrugIndices,type,selectedBrand,selectedGeneric,isparentView;
@synthesize arrBrands,arrDrugPrices,arrSafetyNames,arrSafetyStatus,arrSideEffects,pharmacyParentController,templateParentView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)dealloc{
    
    [super dealloc];
   // [arrDrugIndices release];
    //[arrBrands release];
}
#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    selectedIndex=-1;
     Gen_Brand=0;
    [self reloadViews];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:self.view.window];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:self.view.window];
    txtGenerics.autocorrectionType = UITextAutocorrectionTypeNo;
    txtTopBrand.autocorrectionType = UITextAutocorrectionTypeNo;

   /*
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button setTitle:@"Close" forState:UIControlStateNormal];
	[button setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
	button.bounds = CGRectMake(0,0,button.imageView.image.size.width, 29);
	[button addTarget:self action:@selector(closePopup) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = barButtonItem;
    [barButtonItem release];
    */
    
     
   }

- (void)keyboardDidHide:(NSNotification *)n{
   
}

- (void)keyboardDidShow:(NSNotification *)n {
   
}

-(void)reloadViews {
    
    if (isparentView) {
        
        //  UIBarButtonItem *refreshBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(closePopup)];
        UIBarButtonItem *selectBtn = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonSystemItemAction target:self action:@selector(closePopup)];
        // self.navigationItem.leftBarButtonItems = [[NSArray alloc] initWithObjects: refreshBtn, selectYearBtn, nil];
        navBar.topItem.leftBarButtonItem = selectBtn;
        
    }

    self.service = [[[_GMDocService alloc] init] autorelease];
     tblSideEffects.frame = CGRectMake(tblSideEffects.frame.origin.x, tblSideEffects.frame.origin.y, tblSideEffects.frame.size.width,181);
    if(self.selectedGeneric){
        [txtGenerics setText:[self.selectedGeneric Generic]];
      //  txtGenerics.userInteractionEnabled = NO;
        [btnGeneric setTitle:[self.selectedGeneric Generic] forState:UIControlStateNormal];
       // [btnGeneric setEnabled:FALSE];
        tblBrand.layer.cornerRadius = 10;

        txtCrossRtn.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Crossreaction"];
         [txtCrossRtn setFont:[UIFont systemFontOfSize:14]];
        txtModeOfAction.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"Modeofaction"];
         [txtModeOfAction setFont:[UIFont systemFontOfSize:14]];
        NSArray* safetyObjArray = [[NSUserDefaults standardUserDefaults] valueForKey:@"Safety"];
        self.arrSafetyNames = [[[NSMutableArray alloc] init]autorelease];;
        self.arrSafetyStatus = [[[NSMutableArray alloc] init]autorelease];;
        for (int i=0; i<safetyObjArray.count; i++){
            NSDictionary* safetyTempDict = [safetyObjArray objectAtIndex:i];
            if(![[safetyTempDict objectForKey:@"SafetyPara"] isKindOfClass:[NSNull class]])
                [arrSafetyNames addObject:[safetyTempDict objectForKey:@"SafetyPara"]];
            if(![[safetyTempDict objectForKey:@"SafetyStatus"] isKindOfClass:[NSNull class]])
                [arrSafetyStatus addObject:[safetyTempDict objectForKey:@"SafetyStatus"]];
        }
        NSString* sideEffectsStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"Sideeffect"];
        self.arrSideEffects = [[NSMutableArray alloc] initWithArray:[sideEffectsStr componentsSeparatedByString:@","]];
        if(self.arrBrands.count>0)
            txtDosage.text = [(Brand*)[self.arrBrands objectAtIndex:0] BrandDosage];
         [txtDosage setFont:[UIFont systemFontOfSize:14]];
        
        [tblSafety reloadData];
        [tblSideEffects reloadData];
        [tblBrand reloadData];
    }
    if(self.selectedBrand){
        [txtTopBrand setText:[self.selectedBrand BrandName]];
        self.arrDrugPrices = [self.selectedBrand arrayPrices];
        if (Gen_Brand==GenericfromBrand ||isparentView==YES) {
            isparentView=NO;
        }
        else{
        [tblPrice reloadData];
        }
    }else if(!self.selectedGeneric){
        
        //  self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
       //  NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brands",[DataExchange getbaseUrl]];
        // [self.service getStringResponseInvocation:url Identifier:@"GetBrands" delegate:self];
    }

}
#pragma mark textfield delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if(textField==txtGenerics){
      
        arrDrugIndices = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidGenericRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];
        [tblGeneric reloadData];
        
        tblGeneric.hidden = FALSE;
    }
    
  else  if(textField==txtTopBrand){
        if ([txtGenerics.text isEqualToString:@""]) {
            
            arrBrands = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];;
            [tblBrand reloadData];
            tblBrand.hidden = FALSE;
        }
        else{
            
            arrBrands = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnAllValidBrandRecords:[textField.text stringByReplacingCharactersInRange:range withString:string]]];;
            [tblBrand reloadData];
            tblBrand.hidden = FALSE;
        }
        
        
        
    }

	return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if(textField==txtGenerics){
        txtTopBrand.text = @"";
        
            Gen_Brand=0;
    
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
   // tblGeneric.hidden=NO;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    tblGeneric.hidden=YES;
    return YES;
}

-(void) GetDrugIndexInvocationDidFinish:(GetDrugIndexInvocation *)invocation
                        withDrugIndices:(NSArray *)drugs
                              withError:(NSError *)error{
    if(!error){
        self.arrDrugIndices = [[NSMutableArray alloc] initWithArray:drugs];
        [tblGeneric reloadData];
    }
    if(!self.selectedGeneric && self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

-(void) GetDrugIndexInvocationDidFinish:(GetDrugIndexInvocation *)invocation 
                             withString:(NSString *)responseStr 
                               withType:(NSInteger)typeInt
                              withError:(NSError *)error{
    if(!error){
        if(typeInt==2){
            NSLog(@"%d",responseStr.length);
            NSDictionary* dictTemp = [responseStr JSONValue];
            txtCrossRtn.text = (![[dictTemp objectForKey:@"Crossreaction"] isKindOfClass:[NSNull class]]?[dictTemp objectForKey:@"Crossreaction"]:@"");
            txtModeOfAction.text = (![[dictTemp objectForKey:@"Modeofaction"] isKindOfClass:[NSNull class]]?[dictTemp objectForKey:@"Modeofaction"]:@"");
            NSArray* safetyObjArray = [dictTemp objectForKey:@"Safety"];
            self.arrSafetyNames = [[NSMutableArray alloc] init];
            self.arrSafetyStatus = [[NSMutableArray alloc] init];
            for (int i=0; i<safetyObjArray.count; i++){
                NSDictionary* safetyTempDict = [safetyObjArray objectAtIndex:i];
                if(![[safetyTempDict objectForKey:@"SafetyPara"] isKindOfClass:[NSNull class]])
                    [arrSafetyNames addObject:[safetyTempDict objectForKey:@"SafetyPara"]];
                if(![[safetyTempDict objectForKey:@"SafetyStatus"] isKindOfClass:[NSNull class]])
                    [arrSafetyStatus addObject:[safetyTempDict objectForKey:@"SafetyStatus"]];
            }
            NSString* sideEffectsStr = [dictTemp objectForKey:@"Sideeffect"];
            self.arrSideEffects = [[NSMutableArray alloc] initWithArray:[sideEffectsStr componentsSeparatedByString:@","]];
            NSArray* brandsTemp = [dictTemp objectForKey:@"DrugBrands"];
            self.arrBrands = [[NSMutableArray alloc] initWithArray:[Brand BrandsFromArray:brandsTemp]];
                        
            [tblSafety reloadData];
            [tblSideEffects reloadData];
        }
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
    }
}

-(void) GetStringInvocationDidFinish:(GetStringInvocation *)invocation 
                  withResponseString:(NSString *)responseString 
                      withIdentifier:(NSString *)identifier 
                           withError:(NSError *)error{
    if(!error){
        NSArray* response = [responseString JSONValue];
         //id response = [responseString JSONValue];
        if([identifier isEqualToString:@"GetBrands"]){
            if ([response isKindOfClass:[NSDictionary class]]) {
                NSDictionary* dictTemp=[NSDictionary dictionary];
                dictTemp=[response mutableCopy];
                Brand* brandtemp = [[Brand alloc] init];
                brandtemp.BrandName = [dictTemp objectForKey:@"Name"];
                brandtemp.BrandId = [dictTemp objectForKey:@"Id"];
                [self.arrBrands addObject:brandtemp];
            } //if end
            else{
            self.arrBrands = [[NSMutableArray alloc] init];
            NSDictionary* dictTemp;
            for (int i=0; i<response.count; i++) {
                dictTemp = [response objectAtIndex:i];
                Brand* brandtemp = [[Brand alloc] init];
                brandtemp.BrandName = [dictTemp objectForKey:@"Name"];
                brandtemp.BrandId = [dictTemp objectForKey:@"Id"];
                [self.arrBrands addObject:brandtemp];
            }
            }  //else end
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<self.arrBrands.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[self.arrBrands objectAtIndex:i] ForGenericId:0];
            }
        }
        [self reloadViews];
        [tblPrice reloadData];
        // tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*self.arrBrands.count,260));  //VINAY
    }
    if (self.activityController) {
        [self.activityController dismissActivity];
        self.activityController = Nil;
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
              //  [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:0];
            }
            brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            brandDtlsForDrugView = [[[NSMutableArray alloc] initWithArray:brands] retain];
            
            
          //  self.selectedGeneric= nil;
            self.arrBrands = brandDtlsForDrugView;
            // [tblBrand reloadData];
           //  tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*self.arrBrands.count,260));
            if ([txtGenerics.text isEqualToString:@""]) {
               // Gen_Brand=GenericfromBrand;
               // NSArray* temp = [(Brand*)[brands objectAtIndex:0] arrayGeneric];
                for (int i=0; i<[[(Brand*)[brands objectAtIndex:0] arrayGeneric] count]; i++){
                    self.arrDrugIndices =nil;
                    strgeneric=[NSString stringWithString:[[(PriceObject*)[(Brand*)[brands objectAtIndex:0] arrayGeneric]objectAtIndex:i]PGenericName]];
                    }
                self.arrDrugIndices = [[NSMutableArray alloc] initWithArray:[mCuraSqlite returnSelectedGenericID:strgeneric]];
                currentGeneric = [self.arrDrugIndices objectAtIndex:0];
                self.selectedGeneric= currentGeneric;
                if(!self.activityController){
                    self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
                }
                [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
                [txtGenerics setText:[(Generic*)[self.arrDrugIndices objectAtIndex:0] Generic]];
                  tblGeneric.hidden = YES;

              
                            [self reloadViews];
                       }
                          [tblPrice reloadData];
            
         
        }
        else{
            proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Error!" message:@"Could not find this Brand Details!" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
            [alert show];
            [alert release];
        }
    }
    
    
    
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController{
    return YES;
}


-(IBAction) btnGenericClicked:(id)sender{
    tblGeneric.hidden = FALSE;
    NSLog(@"btnGenericClicked");
}

-(IBAction) clickBrandBtn:(id)sender{
       tblBrand.hidden = FALSE;
     NSLog(@"clickBrandBtn");
}
#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(tableView==tblPrice){
        if(selectedIndex>=0){
            return 1;
        }
        else{
            return [self.arrBrands count];
        }
    }
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView==tblGeneric)
        return arrDrugIndices.count;
    else if(tableView==tblSafety)
        return arrSafetyNames.count;
    else if(tableView==tblSideEffects)
        return arrSideEffects.count;
    else if(tableView == tblBrand)
        //return self.arrBrands.count;
        return arrBrands.count;
       
    else//array price
        return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==tblPrice){
        if(selectedIndex>=0)
            return [[(Brand*)[self.arrBrands objectAtIndex:selectedIndex] arrayPrices] count]*44;
        else
            return [[(Brand*)[self.arrBrands objectAtIndex:indexPath.section] arrayPrices] count]*44;
    }
    else
        return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView==tblGeneric){
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] Generic];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];
     
       
        return cell;
        
    }
    else if(tableView == tblBrand){
        static NSString *CellIdentifier = @"Cell6";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        //Brand *nat = [self.arrBrands objectAtIndex:indexPath.row];
       // cell.textLabel.text = nat.BrandName;
        cell.textLabel.text= [(Brand*)[self.arrBrands objectAtIndex:indexPath.row] BrandName];
        [cell.textLabel setFont:[UIFont systemFontOfSize:16]];

        
        return cell;
    }

    else if(tableView==tblSafety){
        static NSString *CellIdentifier = @"Cell3";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UILabel class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        
        UILabel* lblSafetyName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,120, 44)];
        lblSafetyName.backgroundColor = [UIColor clearColor];
        lblSafetyName.textAlignment = UITextAlignmentCenter;
        lblSafetyName.numberOfLines = 0;
        [lblSafetyName setFont:[UIFont systemFontOfSize:14]];
        lblSafetyName.lineBreakMode = UILineBreakModeWordWrap;
        lblSafetyName.text = [self.arrSafetyNames objectAtIndex:indexPath.row];
        [cell addSubview:lblSafetyName];
        
        UILabel* lblSafetyStatus = [[UILabel alloc] initWithFrame:CGRectMake(120, 0, 66, 44)];
        lblSafetyStatus.backgroundColor = [UIColor clearColor];
        lblSafetyStatus.textAlignment = UITextAlignmentCenter;
        lblSafetyStatus.numberOfLines = 0;
        [lblSafetyStatus setFont:[UIFont systemFontOfSize:14]];
        lblSafetyStatus.lineBreakMode = UILineBreakModeWordWrap;
        lblSafetyStatus.text = [self.arrSafetyStatus objectAtIndex:indexPath.row];
        [cell addSubview:lblSafetyStatus];
        
        return cell;
    }
    else if(tableView==tblSideEffects){
        static NSString *CellIdentifier = @"Cell4";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        cell.textLabel.text = [self.arrSideEffects objectAtIndex:indexPath.row];
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        return cell;
    }
    else{//array price
        static NSString *CellIdentifier = @"Cell5";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        //if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.clipsToBounds=YES;
        //}
        for (UIView* view in [cell subviews]) {
            if([view isKindOfClass:[UILabel class]]){
                [view removeFromSuperview];
                view = nil;
            }
        }
        NSInteger index=indexPath.section;
        if(selectedIndex>=0)
            index=selectedIndex;
        NSInteger cellHeight = cell.frame.size.height;
        UILabel* lblManufacturer = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 96, cellHeight)];
        lblManufacturer.backgroundColor = [UIColor clearColor];
        lblManufacturer.textAlignment = UITextAlignmentCenter;
        lblManufacturer.numberOfLines = 0;
        lblManufacturer.lineBreakMode = UILineBreakModeCharacterWrap;
        lblManufacturer.text = [(Brand*)[self.arrBrands objectAtIndex:index] BrandManufacturer];
        [lblManufacturer setFont:[UIFont systemFontOfSize:13]];
        [cell addSubview:lblManufacturer];
        
        UILabel* lblBrandName = [[UILabel alloc] initWithFrame:CGRectMake(96, 0, 95, cellHeight)];
        lblBrandName.backgroundColor = [UIColor clearColor];
        lblBrandName.textAlignment = UITextAlignmentCenter;
        lblBrandName.numberOfLines = 0;
        lblBrandName.lineBreakMode = UILineBreakModeCharacterWrap;
        lblBrandName.text = [(Brand*)[self.arrBrands objectAtIndex:index] BrandName];
        [lblBrandName setFont:[UIFont systemFontOfSize:13]];
        [cell addSubview:lblBrandName];
        
        UILabel* lblComposition = [[UILabel alloc] initWithFrame:CGRectMake(191, 0, 90, cellHeight)];
        lblComposition.backgroundColor = [UIColor clearColor];
        lblComposition.textAlignment = UITextAlignmentCenter;
        lblComposition.numberOfLines = 0;
        lblComposition.lineBreakMode = UILineBreakModeCharacterWrap;
        lblComposition.text = [(Brand*)[self.arrBrands objectAtIndex:index] BrandComposition];
        [lblComposition setFont:[UIFont systemFontOfSize:13]];
        [cell addSubview:lblComposition];
        
        NSArray* temp = [(Brand*)[self.arrBrands objectAtIndex:index] arrayPrices];
        for (int i=0; i<[[(Brand*)[self.arrBrands objectAtIndex:index] arrayPrices] count]; i++) {
            UILabel* lblDosForm = [[UILabel alloc] initWithFrame:CGRectMake(281, 44*i, 90, 44)];
            lblDosForm.backgroundColor = [UIColor clearColor];
            lblDosForm.textAlignment = UITextAlignmentCenter;
            lblDosForm.numberOfLines = 0;
            lblDosForm.lineBreakMode = UILineBreakModeCharacterWrap;
            lblDosForm.text = [(PriceObject*)[temp objectAtIndex:i] DosageForm];
            [lblDosForm setFont:[UIFont systemFontOfSize:13]];
            [cell addSubview:lblDosForm];
            
            UILabel* lblStrength = [[UILabel alloc] initWithFrame:CGRectMake(371, 44*i, 82, 44)];
            lblStrength.backgroundColor = [UIColor clearColor];
            lblStrength.textAlignment = UITextAlignmentCenter;
            lblStrength.numberOfLines = 0;
            lblStrength.lineBreakMode = UILineBreakModeCharacterWrap;
            lblStrength.text = [(PriceObject*)[temp objectAtIndex:i] Strength];
            [lblStrength setFont:[UIFont systemFontOfSize:13]];
            [cell addSubview:lblStrength];
            
            UILabel* lblPackSize = [[UILabel alloc] initWithFrame:CGRectMake(453, 44*i, 82, 44)];
            lblPackSize.backgroundColor = [UIColor clearColor];
            lblPackSize.textAlignment = UITextAlignmentCenter;
            lblPackSize.numberOfLines = 0;
            lblPackSize.lineBreakMode = UILineBreakModeCharacterWrap;
            lblPackSize.text = [(PriceObject*)[temp objectAtIndex:i] PackSize];
            [lblPackSize setFont:[UIFont systemFontOfSize:13]];
            [cell addSubview:lblPackSize];
            
            UILabel* lblRetailPrice = [[UILabel alloc] initWithFrame:CGRectMake(535, 44*i, 82, 44)];
            lblRetailPrice.backgroundColor = [UIColor clearColor];
            lblRetailPrice.textAlignment = UITextAlignmentCenter;
            lblRetailPrice.numberOfLines = 0;
            lblRetailPrice.lineBreakMode = UILineBreakModeCharacterWrap;
            lblRetailPrice.text = [(PriceObject*)[temp objectAtIndex:i] RetailPrice];
            [lblRetailPrice setFont:[UIFont systemFontOfSize:13]];
            [cell addSubview:lblRetailPrice];
        }
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    /*
    if(tableView==tblGeneric){
        NSInteger genericIdTemp = [[(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] GenericId] integerValue];
        self.selectedGeneric = (Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row];
        [btnGeneric setTitle:[(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] Generic] forState:UIControlStateNormal];
        [txtGenerics setText:[(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] Generic]];
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        [self.service getDrugIndexInvocation:genericIdTemp BrandId:0 Type:2 delegate:self];
        tblGeneric.hidden = TRUE;
    }
  */
    if(tableView == tblGeneric){
         currentGeneric = [self.arrDrugIndices objectAtIndex:indexPath.row];
         self.selectedGeneric= currentGeneric;
        selectedIndex=-1;
     //  NSInteger  currentGenericsIndex = indexPath.row+1;
      // NSInteger currentBrandIdIndex = 0;
        if(!self.activityController){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        }
         [txtGenerics resignFirstResponder];
       [btnGeneric setTitle:[(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] Generic] forState:UIControlStateNormal];
        [txtGenerics setText:[(Generic*)[self.arrDrugIndices objectAtIndex:indexPath.row] Generic]];
        
        NSLog(@"%@",[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]]);
        [self.service getBrandsInvocation:[DataExchange getUserRoleId] GenericId:[NSString stringWithFormat:@"%d",[currentGeneric.GenericId integerValue]] delegate:self];
       // [btnBrand setTitle:@"--Select--" forState:UIControlStateNormal];
        txtTopBrand.text = @"";
        self.selectedBrand=nil;
         Gen_Brand=0;

        tblGeneric.hidden = YES;
    }
    else if(tableView == tblBrand){
        selectedIndex=-1;
        if(!self.activityController){
            self.activityController = [ISActivityOverlayController presentActivityOverViewController:self withLabel:@"Loading..."];
        }
         [txtTopBrand resignFirstResponder];
        currentBrand = (Brand*)[self.arrBrands objectAtIndex:indexPath.row];
         self.selectedBrand = [self.arrBrands objectAtIndex:indexPath.row];
        NSString* url = [NSMutableString stringWithFormat:@"%@DrugIndex_Brand?BrandID=%d",[DataExchange getbaseUrl],[[(Brand*)[self.arrBrands objectAtIndex:indexPath.row] BrandId] integerValue]];
        [self.service getBrandsIDInvocation:[DataExchange getUserRoleId] BrandId:[NSString stringWithFormat:@"%d",[[(Brand*)[self.arrBrands objectAtIndex:indexPath.row] BrandId] integerValue]] delegate:self];   //VINAY  BrandID
        NSLog(@"BRand_rugs_URL is:-%@",url);
       // [self.service getStringResponseInvocation:url Identifier:@"GetBrands" delegate:self];
        [btnBrand setTitle:cell.textLabel.text forState:UIControlStateNormal];
        [txtTopBrand setText:cell.textLabel.text];
        tblBrand.hidden = YES;
        if ([txtGenerics.text isEqualToString:@""]) {
               Gen_Brand=GenericfromBrand;
        }
    }
    else if(tableView==tblPrice){
        if(selectedIndex<0){
            if (Gen_Brand!=GenericfromBrand) {
            
            [txtTopBrand setText:[(Brand*)[self.arrBrands objectAtIndex:indexPath.section] BrandName]];
            self.selectedBrand = [self.arrBrands objectAtIndex:indexPath.section];
            selectedIndex=indexPath.section;
            
            txtDosage.text = self.selectedBrand.BrandDosage;
            [tblPrice reloadData];
            [tblBrand reloadData];
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
            [mCuraSqlite DeleteAllBrands];
            for (int i=0; i<brands.count; i++) {
                [mCuraSqlite InsertANewBrandRecord:[brands objectAtIndex:i] ForGenericId:0];
            }
            
            brandDtls = [[NSMutableArray alloc] initWithArray:brands];
            brandDtlsForDrugView = [[[NSMutableArray alloc] initWithArray:brands] retain];
          //  [self.tblBrand reloadData];
          //  tblBrand.frame = CGRectMake(tblBrand.frame.origin.x, tblBrand.frame.origin.y, tblBrand.frame.size.width, min(20+44*brandDtls.count,260));
           // self.selectedGeneric= currentGeneric;
            self.arrBrands = brandDtlsForDrugView;
//            if(index==1){
//                self.selectedBrand = currentBrand;
                //}
            [self reloadViews];
            if (Gen_Brand==GenericfromBrand) {
                
            }
            else{
            [tblPrice reloadData];
            }
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

-(IBAction) expandTableView:(id)sender{
    switch ([(UIButton*)sender tag]-500) {
        case 1:{
            DosageTableController* controller = [[[DosageTableController alloc] initWithNibName:@"DosageTableController" bundle:nil] autorelease];
            controller.arrBrands = [[NSMutableArray alloc] initWithArray:self.arrBrands];
            [self presentModalViewController:controller animated:YES];
        }
            break;
        case 2:{
            OtherDrugTableController* controller = [[[OtherDrugTableController alloc] initWithNibName:@"OtherDrugTableController" bundle:nil] autorelease];
            controller.arrSideEffects = [[NSMutableArray alloc] initWithArray:self.arrSideEffects];
            controller.type=1;
            [self presentModalViewController:controller animated:YES];
        }
            break;
        case 3:{
            OtherDrugTableController* controller = [[[OtherDrugTableController alloc] initWithNibName:@"OtherDrugTableController" bundle:nil] autorelease];
            controller.arrSafetyNames = [[NSMutableArray alloc] initWithArray:self.arrSafetyNames];
            controller.arrSafetyStatus = [[NSMutableArray alloc] initWithArray:self.arrSafetyStatus];
            controller.type=2;
            [self presentModalViewController:controller animated:YES];
        }
            break;
        default:
            break;
    }
}

-(IBAction)expandTextView:(id)sender{
    NSString* textToShow=@"";
    NSString* title=@"";
    switch ([(UIButton*)sender tag]-400) {
        case 1:
            textToShow = txtModeOfAction.text;
            title=@"Mode Of Action";
            break;
        case 2:
            textToShow = txtCrossRtn.text;
            title=@"Cross Reaction";
            break;
        case 3:
            textToShow = txtDosage.text;
            title=@"Dosage";
            break;
        default:
            break;
    }
    UIViewController* controller = [[[UIViewController alloc] init] autorelease];
    UITextView* txtView = [[[UITextView alloc] initWithFrame:CGRectMake(0, 44, 800, 516)] autorelease];
    txtView.text = textToShow;
    txtView.editable = false;
    txtView.font = [UIFont systemFontOfSize:19];
    [controller.view setBackgroundColor:[UIColor whiteColor]];
    [controller.view addSubview:txtView];
    
    UILabel* topBar = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 800, 44)];
    [topBar setBackgroundColor:[UIColor lightGrayColor]];
    [topBar setFont:[UIFont boldSystemFontOfSize:20]];
    [topBar setTextAlignment:UITextAlignmentCenter];
    [topBar setText:title];
    UIButton* closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeBtn setFrame:CGRectMake(5, 9, 42, 26)];
    [closeBtn setBackgroundImage:[UIImage imageNamed:@"done.png"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closePopover) forControlEvents:UIControlEventTouchUpInside];
    [controller.view addSubview:topBar];
    [controller.view addSubview:closeBtn];
    
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    popover.popoverContentSize = CGSizeMake(800, 560);
    popover.delegate = self;
    [popover presentPopoverFromRect:CGRectMake(512, 0, 20, 20) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(BOOL)popoverControllerShouldDismissPopover:(UIPopoverController *)popoverController{
    return NO;
}

-(void)closePopover{
    if(popover)
        if([popover isPopoverVisible])
            [popover dismissPopoverAnimated:YES];
}

-(IBAction)closePopup{
    if(self.selectedBrand){
        proAlertView *alert = [[proAlertView alloc] initWithTitle:@"Alert!" message:@"Would you like to use currently selected generic and brand?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes",nil];
        [alert setBackgroundColor:[UIColor colorWithRed:0.129 green:0.129 blue:0.129 alpha:1.0] withStrokeColor:[UIColor colorWithHue:0.625 saturation:0.0 brightness:0.8 alpha:0.8]];
        [alert show];
        [alert release];
        return;
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    tblGeneric.hidden = TRUE;
     tblBrand.hidden = TRUE;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        if(self.pharmacyParentController){
            if(self.selectedBrand)
                [self.pharmacyParentController setBrand:self.selectedBrand];
            if(self.selectedGeneric)
                [self.pharmacyParentController setGeneric:self.selectedGeneric];
        }
        if(self.templateParentView){
            if(self.selectedBrand)
                [self.templateParentView setBrand:self.selectedBrand];
            if(self.selectedGeneric)
                [self.templateParentView setGeneric:self.selectedGeneric];
        }
    }
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // return UIInterfaceOrientationIsLandscape(interfaceOrientation);
    return UIInterfaceOrientationLandscapeRight;
}

@end

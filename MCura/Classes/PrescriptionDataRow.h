//
//  PrescriptionDataRow.h
//  mCura
//
//  Created by Aakash Chaudhary on 21/10/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrescriptionDataRow : UIView{
    IBOutlet UILabel* lblGeneric;
    IBOutlet UILabel* lblBrand;
    IBOutlet UILabel* lblDosageForm;
    IBOutlet UILabel* lblDosage;
    IBOutlet UILabel* lblInstruction;
    IBOutlet UILabel* lblFollowUp;
}

@property (nonatomic, retain) NSString *genericStr;
@property (nonatomic, retain) NSString *dosageStr;
@property (nonatomic, retain) NSString *brandStr;
@property (nonatomic, retain) NSString *instructionStr;
@property (nonatomic, retain) NSString *dosageFrmStr;
@property (nonatomic, retain) NSString *followUpStr;

-(void)reloadView;
-(UIImage*)imageForView;

@end

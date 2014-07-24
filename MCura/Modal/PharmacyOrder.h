//
//  PharmacyOrder.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PharmacyOrder : NSObject

@property (nonatomic,retain) NSString * Generic;
@property (nonatomic,retain) NSNumber * generic_id;
@property (nonatomic,retain) NSNumber * brand_id;
@property (nonatomic,retain) NSString * brand_name;
@property (nonatomic,retain) NSString * dosage;
@property (nonatomic,retain) NSString * dosage_form;
@property (nonatomic,retain) NSNumber * dosage_form_id;
@property (nonatomic,retain) NSNumber * dosage_id;
@property (nonatomic,retain) NSNumber * dosage_ins_id;
@property (nonatomic,retain) NSNumber * durationno;
@property (nonatomic,retain) NSString * durationunits;
@property (nonatomic,retain) NSNumber * followup_id;
@property (nonatomic,retain) NSString * instruction;
@property (nonatomic,retain) NSNumber * med_id;
@property (nonatomic,retain) NSNumber * prescription_id;
@property (nonatomic,assign) BOOL isTemplate;

@end
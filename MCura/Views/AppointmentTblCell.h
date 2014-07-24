//
//  AppointmentTblCell.h
//  mCura
//
//  Created by Aakash Chaudhary on 02/04/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface AppointmentTblCell : UITableViewCell {
    
}

+(AppointmentTblCell*) createTextRowWithOwner:(NSObject*)owner;
@property (nonatomic, retain) IBOutlet UILabel *lblMobNo;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblMrno;
@property (nonatomic, retain) IBOutlet UILabel *lblAge;
@property (nonatomic, retain) IBOutlet UILabel *lblSex;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;

@end

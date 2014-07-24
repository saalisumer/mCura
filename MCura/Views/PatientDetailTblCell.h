//
//  PatientDetailTblCell.h
//  3GMDoc
//
//  Created by sandeep agrawal on 20/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PatientDetailTblCell : UITableViewCell {
    
}

+(PatientDetailTblCell*) createTextRowWithOwner:(NSObject*)owner;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UILabel *lblType;
@property (nonatomic, retain) IBOutlet UILabel *lblExistsFrom;

@end

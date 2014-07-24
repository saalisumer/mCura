//
//  NatureTblCell.h
//  3GMDoc
//
//  Created by sandeep agrawal on 14/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NatureTblCell : UITableViewCell {
    
}

+(NatureTblCell*) createTextRowWithOwner:(NSObject*)owner;
@property (nonatomic, retain) IBOutlet UILabel *lblAppTime;
@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (nonatomic, retain) IBOutlet UIImageView *imgView;

@end

//
//  PatMedRecords.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 05/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PatMedRecords : NSObject{
    
}

@property(nonatomic, retain) NSString *Date;
@property(nonatomic, retain) NSNumber *EntryTypeId;
@property(nonatomic, retain) NSString *Mrno;
@property(nonatomic, retain) NSString *RecNatureId;
@property(nonatomic, retain) NSString *RecordId;
@property(nonatomic, retain) NSString *UserRoleId;
@property(nonatomic, retain) NSString *ImagePath;

@end

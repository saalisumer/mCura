//
//  PriorityObject.h
//  mCura
//
//  Created by Aakash Chaudhary on 09/06/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PriorityObject : NSObject

@property (nonatomic,retain) NSNumber * priorityId;
@property (nonatomic,retain) NSNumber * appDuration;
@property (nonatomic,retain) NSNumber * appSlotId;
@property (nonatomic,retain) NSString * priorityName;

@end

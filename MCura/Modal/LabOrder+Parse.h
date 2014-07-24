//
//  LabOrder+Parse.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 15/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LabOrder.h"

@interface LabOrder (Parse)

+(LabOrder*) LabOrderFromDictionary:(NSDictionary*)LabOrderD;

@end

//
//  Instruction+Parse.h
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Instruction.h"

@interface Instruction (Parse)

+(Instruction*) InstructionsFromDictionary:(NSDictionary*)Instructionsd;
+(NSArray*) InstructionsFromArray:(NSArray*) InstructionsA;

@end

//
//  Instruction+Parse.m
//  3GMDoc
//
//  Created by sandeep agrawal on 18/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import "Instruction+Parse.h"

@implementation Instruction (Parse)

+(Instruction*) InstructionsFromDictionary:(NSDictionary*)Instructionsd{
	if (!Instructionsd) {
		return Nil;
	}
	
	Instruction *app = [[[Instruction alloc] init] autorelease];
    
    app.DosageInsId = [Instructionsd objectForKey:@"DosageInsId"];
    app.Instruction = [Instructionsd objectForKey:@"Instruction"];
    
	return app;
    
}

+(NSArray*) InstructionsFromArray:(NSArray*) InstructionsA{
	if (!InstructionsA || [InstructionsA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < InstructionsA.count; i++) {
        Instruction *sch = [Instruction InstructionsFromDictionary:[InstructionsA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;	
}


@end

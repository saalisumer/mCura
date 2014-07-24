//
//  Template+Parse.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "Template+Parse.h"

@implementation Template (Parse)

+(Template*) TemplatesFromDictionary:(NSDictionary*)Templatesd{
    if (!Templatesd) {
		return Nil;
	}
	
	Template *app = [[[Template alloc] init] autorelease];
#if 1
    app.TemplateName = [Templatesd objectForKey:@"TemplateName"];
    app.TemplateId = [Templatesd objectForKey:@"TemplateId"];
    app.UserRoleId = [Templatesd objectForKey:@"UserRoleId"];
#else
    app.TemplateName = [Templatesd objectForKey:@"<TemplateName>k__BackingField"];
    app.TemplateId = [Templatesd objectForKey:@"<TemplateId>k__BackingField"];
    app.UserRoleId = [Templatesd objectForKey:@"<UserRoleId>k__BackingField"];
#endif
    
	return app;
}

+(NSArray*) TemplatesFromArray:(NSArray*) TemplatesA{
    if (!TemplatesA || [TemplatesA isKindOfClass:[NSNull class]]) {
		return Nil;
	}
	
	NSMutableArray *appointments = [[[NSMutableArray alloc] init] autorelease];
    for (int i = 0; i < TemplatesA.count; i++) {
        Template *sch = [Template TemplatesFromDictionary:[TemplatesA objectAtIndex:i]];
        if (sch) {
            [appointments addObject:sch];
        }
    }    
	
	return appointments;
}

@end

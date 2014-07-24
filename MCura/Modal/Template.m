//
//  Template.m
//  mCura
//
//  Created by Aakash Chaudhary on 24/03/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import "Template.h"

@implementation Template
@synthesize TemplateId,TemplateName,UserRoleId,ConnectionString;

-(void)dealloc 
{
    self.TemplateId = nil;
    self.TemplateName = nil;
    self.UserRoleId = nil;
    self.ConnectionString = nil;
	[super dealloc];
}
@end

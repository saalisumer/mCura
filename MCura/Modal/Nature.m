//
//  Nature.m
//  3GMDoc

#import "Nature.h"

@implementation Nature

@synthesize AppNatureIdProperty,AppNature;

-(void)dealloc 
{
    self.AppNatureIdProperty = nil;
    self.AppNature = nil;
    
	[super dealloc];
}

@end

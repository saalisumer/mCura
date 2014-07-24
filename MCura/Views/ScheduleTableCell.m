//
//  ScheduleTableCell.m
//  3GMDoc

#import "ScheduleTableCell.h"
#import "CAVNSArrayTypeCategory.h"

@implementation ScheduleTableCell

@synthesize lblTime, lblDiscription, cellDelegate, btnLock, btnMove,btnDelete, btnDesc, selectedScheduleIndex;


+(ScheduleTableCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate{
	NSArray* wired = [[NSBundle mainBundle] loadNibNamed:@"ScheduleTableCell" owner:owner options:nil];
	ScheduleTableCell* cell = (ScheduleTableCell*)[wired firstObjectWithClass:[ScheduleTableCell class]];
	cell.cellDelegate = delegate;
	return cell;
}

-(IBAction)changeFixBtnValue:(id)sender{
    
    if ([self.cellDelegate respondsToSelector:@selector(changeFixBtnValue:)]) {
		[self.cellDelegate changeFixBtnValue:self];
	}
}
-(IBAction)changeBlockBtnValue:(id)sender{

    if ([self.cellDelegate respondsToSelector:@selector(changeBlockBtnValue:)]) {
		[self.cellDelegate changeBlockBtnValue:self];
	}
}

-(IBAction)lockBtnClick:(id)sender{
    
    if ([self.cellDelegate respondsToSelector:@selector(lockBtnClick:)]) {
		[self.cellDelegate lockBtnClick:self];
	}

}

-(IBAction)descBtnClick:(id)sender{

    if ([self.cellDelegate respondsToSelector:@selector(descBtnClick:)]) {
		[self.cellDelegate descBtnClick:self];
	}
}

- (void)dealloc {
    self.btnMove = Nil;
	self.btnDelete = Nil;
	self.lblTime = Nil;
    self.lblDiscription = Nil;
    self.cellDelegate = Nil;
    [super dealloc];
}

@end

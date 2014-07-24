//
//  ScheduleTableCell.h
//  3GMDoc

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@class ScheduleTableCell;
@protocol ScheduleTableCellDelegate <NSObject>

@optional
    -(void) changeFixBtnValue:(ScheduleTableCell*)cellValue;
    -(void) changeBlockBtnValue:(ScheduleTableCell*)cellValue;
    -(void) lockBtnClick:(ScheduleTableCell*)cellValue;
    -(void) descBtnClick:(ScheduleTableCell*)cellValue;
@end

@interface ScheduleTableCell : UITableViewCell <UITextFieldDelegate> {
     
}

+(ScheduleTableCell*) createTextRowWithOwner:(NSObject*)owner withDelegate:(id)delegate;
-(IBAction)changeFixBtnValue:(id)sender;
-(IBAction)changeBlockBtnValue:(id)sender;
-(IBAction)lockBtnClick:(id)sender;
-(IBAction)descBtnClick:(id)sender;

@property (nonatomic,retain) IBOutlet UILabel *lblTime;
@property (nonatomic,retain) IBOutlet UILabel *lblDiscription;
@property (nonatomic,retain) IBOutlet UIButton *btnMove;
@property (nonatomic,retain) IBOutlet UIButton *btnDelete;
@property (nonatomic,retain) IBOutlet UIButton *btnLock;
@property (nonatomic,retain) IBOutlet UIButton *btnDesc;
@property (nonatomic, assign) NSInteger selectedScheduleIndex;

@property (nonatomic, assign) id<ScheduleTableCellDelegate> cellDelegate;


@end

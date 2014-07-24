//
//  STPNDatePickerViewController.h
//  3GMDoc
//  Created by sandeep agrawal on 08/01/12.
//  Copyright (c) 2012 student.san1986@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STPNDatePickerDelegate <NSObject>

- (void) closePopUpDate:(NSString*)dt;

@end

@interface STPNDatePickerViewController : UIViewController{

    id <STPNDatePickerDelegate> delegate;
}

@property (nonatomic, retain) IBOutlet UIDatePicker *datePicker;
@property (assign) id<STPNDatePickerDelegate> delegate;

-(IBAction)clickBtnDone:(id)sender;
-(IBAction)clickBtnCancel:(id)sender;

@end

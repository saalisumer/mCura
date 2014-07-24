//
//  ReportsView.h
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"
#import "GraphObject.h"
#import "ISActivityOverlayController.h"
#import "UserAccountViewController.h"
#import "Response.h"
#import "_GMDocService.h"
#import "SubTenantsViewcontroller.h"

@interface ReportsView : UIView<CPTPlotDataSource,NSURLConnectionDelegate,SubTenantsChoiceDelegate,GetSubtenIdInvocationDelegate>{
    IBOutlet UINavigationBar* childNavBar;
    IBOutlet UIView* chartsView;
    IBOutlet UIView* dataView;
    IBOutlet UILabel* lblPresThis;
    IBOutlet UILabel* lblPresLast;
    IBOutlet UILabel* lblPatThis;
    IBOutlet UILabel* lblPatLast;
    IBOutlet UILabel* lblLabThis;
    IBOutlet UILabel* lblLabLast;
    IBOutlet UILabel* lblRefThis;
    IBOutlet UILabel* lblRefLast;
    BOOL isMonthNotWeek;
    NSURLConnection* connPrescr;
    NSURLConnection* connLabOrder;
    NSURLConnection* connPatients;
    NSURLConnection* connReferrals;
    NSInteger pendingConnections;
    NSMutableArray* arraySubTenants;
    IBOutlet UIBarButtonItem* hospitalSelectButton;
}

@property (nonatomic, retain) UIPopoverController * popover;
@property (nonatomic, retain) ISActivityOverlayController *activityController;
@property (nonatomic, retain) _GMDocService *service;
@property (nonatomic, retain) UserAccountViewController* mParentController;
@property (nonatomic, retain) NSMutableArray* arrPrescrObjMonth;
@property (nonatomic, retain) NSMutableArray* arrLabOrderObjMonth;
@property (nonatomic, retain) NSMutableArray* arrReferralsObjMonth;
@property (nonatomic, retain) NSMutableArray* arrPatObjMonth;
@property (nonatomic, retain) CPTXYGraph *graph1;
@property (nonatomic, retain) CPTXYGraph *graph2;
@property (nonatomic, retain) CPTXYGraph *graph3;
@property (nonatomic, retain) CPTXYGraph *graph4;

-(id)initWithParent:(UserAccountViewController*)parent;
-(void)showGraphFor:(CPTXYGraph*)graph WithTitle:(NSString*)title;
-(IBAction)toggleChartsAndData:(id)sender;
-(IBAction)toggleMonthAndWeek:(id)sender;
-(IBAction)selectHospital:(id)sender;

@end

//
//  ReportsView.m
//  mCura
//
//  Created by Aakash Chaudhary on 09/05/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ReportsView.h"
#import "DataExchange.h"
#import "SubTenant.h"
#import <QuartzCore/QuartzCore.h>
#define numOfMonthsOrWeeks 2

@implementation ReportsView
@synthesize activityController,graph1,graph2,graph3,graph4,mParentController;
@synthesize arrPatObjMonth,arrPrescrObjMonth,arrLabOrderObjMonth,arrReferralsObjMonth;
@synthesize service,popover;

-(id)initWithParent:(UserAccountViewController*)parent{
    if ((self = [super init])) {
        NSArray * nib = [[NSBundle mainBundle] loadNibNamed: @"ReportsView" owner: self options: nil];
        // prevent memory leak
        [self release];
        self = [[nib objectAtIndex:0] retain];
    }
    mParentController = parent;
    self.service = [[[_GMDocService alloc] init] autorelease];
    [self.service getSubTenantIdInvocation:[DataExchange getUserRoleId] delegate:self];
    if(!self.activityController)
        self.activityController = [ISActivityOverlayController presentActivityOverViewController:mParentController withLabel:@"Loading..."];
    isMonthNotWeek = true;
    pendingConnections=4*numOfMonthsOrWeeks;
    childNavBar.layer.cornerRadius = 5.0;
    self.arrPatObjMonth = [[NSMutableArray alloc] init];
    self.arrPrescrObjMonth = [[NSMutableArray alloc] init];
    self.arrLabOrderObjMonth = [[NSMutableArray alloc] init];
    self.arrReferralsObjMonth = [[NSMutableArray alloc] init];
    
    GraphObject* prescrObj = [[GraphObject alloc] init];
    GraphObject* labOrderObj = [[GraphObject alloc] init];
    GraphObject* referralsObj = [[GraphObject alloc] init];
    GraphObject* patObj = [[GraphObject alloc] init];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        
    NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents setMonth:-2];
    NSDateComponents *dateComponents2 = [[[NSDateComponents alloc] init] autorelease];
    [dateComponents2 setMonth:-1];
    
    prescrObj.toDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:[NSDate date] options:0]];
    labOrderObj.toDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:[NSDate date] options:0]];
    referralsObj.toDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:[NSDate date] options:0]];
    patObj.toDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents2 toDate:[NSDate date] options:0]];
    
    prescrObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
    labOrderObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
    referralsObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
    patObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
        
    NSMutableURLRequest* request1 = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url1 = [NSMutableString stringWithFormat:@"http://%@GetPharmacyOrderCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl],prescrObj.fromDate,prescrObj.toDate,[DataExchange getUserRoleId]];
	[request1 setURL:[NSURL URLWithString:url1]];
	[request1 setHTTPMethod:@"GET"];
    connPrescr = [[[NSURLConnection alloc] initWithRequest:request1 delegate:self] autorelease];
    
    NSMutableURLRequest* request2 = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url2 = [NSMutableString stringWithFormat:@"http://%@GetLabOrderCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl], labOrderObj.fromDate,labOrderObj.toDate,[DataExchange getUserRoleId]];
	[request2 setURL:[NSURL URLWithString:url2]];
	[request2 setHTTPMethod:@"GET"];
    connLabOrder = [[[NSURLConnection alloc] initWithRequest:request2 delegate:self] autorelease];
    
    NSMutableURLRequest* request3 = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url3 = [NSMutableString stringWithFormat:@"http://%@GetAppointmentCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl], patObj.fromDate,patObj.toDate,[DataExchange getUserRoleId]];
	[request3 setURL:[NSURL URLWithString:url3]];
	[request3 setHTTPMethod:@"GET"];
    connPatients = [[[NSURLConnection alloc] initWithRequest:request3 delegate:self] autorelease];
    
    NSMutableURLRequest* request4 = [[[NSMutableURLRequest alloc] init] autorelease]; 
	NSString* url4 = [NSMutableString stringWithFormat:@"http://%@GetReferralsCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl], referralsObj.fromDate,referralsObj.toDate,[DataExchange getUserRoleId]];
	[request4 setURL:[NSURL URLWithString:url4]];
	[request4 setHTTPMethod:@"GET"];
    connReferrals = [[[NSURLConnection alloc] initWithRequest:request4 delegate:self] autorelease];
    
    [arrLabOrderObjMonth addObject:labOrderObj];
    [arrPatObjMonth addObject:patObj];
    [arrPrescrObjMonth addObject:prescrObj];
    [arrReferralsObjMonth addObject:referralsObj];
    
    self.graph1 = [[[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 4, 352, 305)] autorelease];
    self.graph2 = [[[CPTXYGraph alloc] initWithFrame:CGRectMake(352, 4, 352, 305)] autorelease];
    self.graph3 = [[[CPTXYGraph alloc] initWithFrame:CGRectMake(0, 310, 352, 305)] autorelease];
    self.graph4 = [[[CPTXYGraph alloc] initWithFrame:CGRectMake(352, 310, 352, 305)] autorelease];
    
    return self;
}

-(IBAction)toggleChartsAndData:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            chartsView.hidden = false;
            dataView.hidden = true;
            break;
        case 1:
            chartsView.hidden = true;
            dataView.hidden = false;
            break;
        default:
            break;
    }
}

-(void)GetSubtenIdInvocationDidFinish:(GetSubtenIdInvocation *)invocation 
                     withSubTenantIds:(NSArray *)subTenantIds
                            withError:(NSError *)error{
    if(!error){
        arraySubTenants = [[NSMutableArray alloc] initWithArray:subTenantIds];
    }
    if(self.activityController){
        [self.activityController dismissActivity];
        self.activityController = nil;
    }
}

-(IBAction)selectHospital:(id)sender{
    SubTenantsViewcontroller* controller = [[SubTenantsViewcontroller alloc] initWithNibName:@"SubTenantsViewcontroller" bundle:nil];
    controller.arraySubTenants = arraySubTenants;
    controller.delegate = self;
    popover = [[UIPopoverController alloc] initWithContentViewController:controller];
    [controller release];
    [popover setPopoverContentSize:CGSizeMake(400, 20 + 50*[arraySubTenants count])];
    [popover presentPopoverFromRect:CGRectMake(620, 10, 50, 20) inView:self permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)subTenantChoice:(NSInteger)index{
    [popover dismissPopoverAnimated:YES];
    [hospitalSelectButton setTitle:[(SubTenant*)[arraySubTenants objectAtIndex:index] SubTenantName]];
    
}

-(IBAction)toggleMonthAndWeek:(id)sender{
    UISegmentedControl *segmentedControl = (UISegmentedControl *) sender;
    NSInteger selectedSegment = segmentedControl.selectedSegmentIndex;
    switch (selectedSegment) {
        case 0:
            if(!isMonthNotWeek){
                isMonthNotWeek = true;
                CPTXYPlotSpace *plotSpace1 = (CPTXYPlotSpace *)graph1.defaultPlotSpace;
                plotSpace1.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace1.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *)graph2.defaultPlotSpace;
                plotSpace2.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace3 = (CPTXYPlotSpace *)graph3.defaultPlotSpace;
                plotSpace3.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace3.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace4 = (CPTXYPlotSpace *)graph4.defaultPlotSpace;
                plotSpace4.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace4.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
            }
            break;
        case 1:
            if(isMonthNotWeek){
                isMonthNotWeek = false;
                CPTXYPlotSpace *plotSpace1 = (CPTXYPlotSpace *)graph1.defaultPlotSpace;
                plotSpace1.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace1.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace2 = (CPTXYPlotSpace *)graph2.defaultPlotSpace;
                plotSpace2.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace2.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace3 = (CPTXYPlotSpace *)graph3.defaultPlotSpace;
                plotSpace3.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace3.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
                
                CPTXYPlotSpace *plotSpace4 = (CPTXYPlotSpace *)graph4.defaultPlotSpace;
                plotSpace4.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1*numOfMonthsOrWeeks+1)];
                plotSpace4.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromUnsignedInteger(-1) length:CPTDecimalFromUnsignedInteger(1)];
            }
            break;
        default:
            break;
    }
}

-(void)showGraphFor:(CPTXYGraph*)graph WithTitle:(NSString*)title{    
    CPTTheme *theme = [CPTTheme themeNamed:kCPTPlainWhiteTheme];
    [graph applyTheme:theme];
    
    CPTGraphHostingView *hostingView = [[[CPTGraphHostingView alloc] initWithFrame:graph.frame] autorelease];
    hostingView.hostedGraph = graph;
    graph.paddingLeft = 20.0;
    graph.paddingTop = 20.0;
    graph.paddingRight = 20.0;
    graph.paddingBottom = 20.0;
    int length =0;
    if([title isEqualToString:@"Prescriptions"]){
        for (int i=0; i<arrPrescrObjMonth.count; i++) {
            int temp = [[(GraphObject*)[arrPrescrObjMonth objectAtIndex:i] count] integerValue];
            length = (temp>length?temp:length);
        }
    }
    else if([title isEqualToString:@"Lab Orders"]){
        for (int i=0; i<arrLabOrderObjMonth.count; i++) {
            int temp = [[(GraphObject*)[arrLabOrderObjMonth objectAtIndex:i] count] integerValue];
            length = (temp>length?temp:length);
        }
    }
    else if([title isEqualToString:@"Patients"]){
        for (int i=0; i<arrPatObjMonth.count; i++) {
            int temp = [[(GraphObject*)[arrPatObjMonth objectAtIndex:i] count] integerValue];
            length = (temp>length?temp:length);
        }
    }
    else if([title isEqualToString:@"Referrals"]){
        for (int i=0; i<arrReferralsObjMonth.count; i++) {
            int temp = [[(GraphObject*)[arrReferralsObjMonth objectAtIndex:i] count] integerValue];
            length = (temp>length?temp:length);
        }
    }
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *)graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-0.5)
                                                    length:CPTDecimalFromFloat(1*numOfMonthsOrWeeks+1)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(-length/5.0) 
                                                    length:CPTDecimalFromFloat(1+(5*length)/4.0)];
    
    CPTMutableLineStyle *lineStyle = [CPTMutableLineStyle lineStyle];
    lineStyle.lineColor = [CPTColor blackColor];
    lineStyle.lineWidth = 2.0f;
    
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *)graph.axisSet;
    axisSet.xAxis.axisLineStyle	= lineStyle;
	axisSet.xAxis.majorTickLineStyle = lineStyle;
	axisSet.xAxis.minorTickLineStyle = lineStyle;
    axisSet.xAxis.majorIntervalLength = CPTDecimalFromString([NSString stringWithFormat:@"%d",1*numOfMonthsOrWeeks+1]);
    axisSet.xAxis.majorTickLength = 7.0f;
    axisSet.xAxis.majorTickLength = 7.0f;
	axisSet.xAxis.orthogonalCoordinateDecimal = CPTDecimalFromString(@"0");
	axisSet.xAxis.minorTicksPerInterval = 0;

    NSMutableArray *xAxisLabels = [[[NSMutableArray alloc] init] autorelease];
    [xAxisLabels addObject:@"Last Month"];
    [xAxisLabels addObject:@"This Month"];
    NSUInteger labelLocation = 0;
    NSMutableArray *customLabels = [NSMutableArray arrayWithCapacity:[xAxisLabels count]+1];
    
    for (NSInteger i = 0; i < xAxisLabels.count; i++) {
        CPTAxisLabel *newLabel = [[CPTAxisLabel alloc] initWithText: [xAxisLabels objectAtIndex:labelLocation++] textStyle:axisSet.xAxis.labelTextStyle];
        newLabel.tickLocation = [[NSNumber numberWithInt:i+1] decimalValue];
        newLabel.offset = axisSet.xAxis.labelOffset + axisSet.xAxis.majorTickLength;
        newLabel.rotation = 0;
        [customLabels addObject:newLabel];
        [newLabel release];
    }
    axisSet.xAxis.axisLabels =  [NSSet setWithArray:customLabels];
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.labelRotation = 0;
    
    axisSet.yAxis.majorIntervalLength = CPTDecimalFromString([NSString stringWithFormat:@"%d",2*length]);
    axisSet.yAxis.minorTicksPerInterval = 2;
    axisSet.yAxis.majorTickLineStyle = lineStyle;
    axisSet.yAxis.minorTickLineStyle = lineStyle;
    axisSet.yAxis.axisLineStyle = lineStyle;
    axisSet.yAxis.minorTickLength = 5.0f;
    axisSet.yAxis.majorTickLength = 7.0f;
    axisSet.yAxis.labelOffset = 3.0f;
    axisSet.yAxis.title = @"";
    axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyAutomatic;
    
    CPTScatterPlot *xSquaredPlot = [[[CPTScatterPlot alloc] initWithFrame:graph.bounds] autorelease];
    xSquaredPlot.identifier = title;
    CPTMutableLineStyle *plotLineStyle = [[xSquaredPlot.dataLineStyle mutableCopy] autorelease];
    plotLineStyle.lineWidth = 1.0f;
    plotLineStyle.lineColor = [CPTColor blackColor];
    xSquaredPlot.dataLineStyle = plotLineStyle;
    xSquaredPlot.dataSource = self;
    
    CPTPlotSymbol *greenCirclePlotSymbol = [CPTPlotSymbol ellipsePlotSymbol];
    greenCirclePlotSymbol.fill = [CPTFill fillWithColor:[CPTColor lightGrayColor]];
    greenCirclePlotSymbol.size = CGSizeMake(10.0, 10.0);
    xSquaredPlot.plotSymbol = greenCirclePlotSymbol;
    [graph addPlot:xSquaredPlot];
    
    [chartsView addSubview:hostingView];
    
    CGRect rect;
    if(graph==self.graph1)
        rect = CGRectMake(0, 0, 352, 20);
    else if(graph==self.graph2)
        rect = CGRectMake(352, 0, 352, 20);
    else if(graph==self.graph3)
        rect = CGRectMake(0, 305, 352, 20);
    else if(graph==self.graph4)
        rect = CGRectMake(352, 305, 352, 20);
    
    UILabel* titleLbl = [[UILabel alloc] initWithFrame:rect];
    titleLbl.text = title;
    titleLbl.textColor = [UIColor blackColor];
    titleLbl.backgroundColor = [UIColor clearColor];
    titleLbl.textAlignment = UITextAlignmentCenter;
    [chartsView addSubview:titleLbl];
    [titleLbl release];
    
}

-(NSUInteger)numberOfRecordsForPlot:(CPTPlot*)plot{
    return numOfMonthsOrWeeks;
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index{
    double val = index;
    int length =0;
    if([(NSString*)plot.identifier isEqualToString:@"Prescriptions"]){
        length = [[(GraphObject*)[arrPrescrObjMonth objectAtIndex:index] count] integerValue];
    }
    else if([(NSString*)plot.identifier isEqualToString:@"Lab Orders"]){
        length = [[(GraphObject*)[arrLabOrderObjMonth objectAtIndex:index] count] integerValue];
    }
    else if([(NSString*)plot.identifier isEqualToString:@"Patients"]){
        length = [[(GraphObject*)[arrPatObjMonth objectAtIndex:index] count] integerValue];
    }
    else if([(NSString*)plot.identifier isEqualToString:@"Referrals"]){
        length = [[(GraphObject*)[arrReferralsObjMonth objectAtIndex:index] count] integerValue];
    }
    
    if(fieldEnum == CPTScatterPlotFieldX){ 
        return [NSNumber numberWithDouble:val+1];
    }
    else{        
        return [NSNumber numberWithInteger:length];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{	
    if (self.activityController && pendingConnections==0){
		[self.activityController dismissActivity];
		self.activityController = Nil;
	}
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    NSString *newStr = [[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding] autorelease];
    NSLog(@"---%@",newStr);
    
    newStr = [newStr stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    if(pendingConnections>4){
        if(connection==connPrescr){
            ((GraphObject*)[arrPrescrObjMonth objectAtIndex:0]).count = newStr;
            [lblPresLast setText:newStr];
            pendingConnections--;
        }
        else if(connection==connLabOrder){
            ((GraphObject*)[arrLabOrderObjMonth objectAtIndex:0]).count = newStr;
            [lblLabLast setText:newStr];
            pendingConnections--;
        }
        else if(connection==connPatients){
            ((GraphObject*)[arrPatObjMonth objectAtIndex:0]).count = newStr;
            [lblPatLast setText:newStr];
            pendingConnections--;
        }
        else if(connection==connReferrals){
            ((GraphObject*)[arrReferralsObjMonth objectAtIndex:0]).count = newStr;
            [lblRefLast setText:newStr];
            pendingConnections--;
        }
    }else{
        if(connection==connPrescr){
            ((GraphObject*)[arrPrescrObjMonth objectAtIndex:1]).count = newStr;
            [self showGraphFor:self.graph3 WithTitle:@"Prescriptions"];
            [lblPresThis setText:newStr];
            pendingConnections--;
        }
        else if(connection==connLabOrder){
            ((GraphObject*)[arrLabOrderObjMonth objectAtIndex:1]).count = newStr;
            [self showGraphFor:self.graph4 WithTitle:@"Lab Orders"];
            [lblLabThis setText:newStr];
            pendingConnections--;
        }
        else if(connection==connPatients){
            ((GraphObject*)[arrPatObjMonth objectAtIndex:1]).count = newStr;
            [self showGraphFor:self.graph1 WithTitle:@"Patients"];
            [lblPatThis setText:newStr];
            pendingConnections--;
        }
        else if(connection==connReferrals){
            ((GraphObject*)[arrReferralsObjMonth objectAtIndex:1]).count = newStr;
            [self showGraphFor:self.graph2 WithTitle:@"Referrals"];
            [lblRefThis setText:newStr];
            pendingConnections--;
        }
    }
    if(pendingConnections==4){
        GraphObject* prescrObj = [[[GraphObject alloc] init] autorelease];
        GraphObject* labOrderObj = [[[GraphObject alloc] init] autorelease];
        GraphObject* referralsObj = [[[GraphObject alloc] init] autorelease];
        GraphObject* patObj = [[[GraphObject alloc] init] autorelease];
        
        NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd-MMM-yyyy"];
        
        NSDateComponents *dateComponents = [[[NSDateComponents alloc] init] autorelease];
        [dateComponents setMonth:-1];
        
        prescrObj.toDate = [dateFormatter stringFromDate:[NSDate date]];
        labOrderObj.toDate = [dateFormatter stringFromDate:[NSDate date]];
        referralsObj.toDate = [dateFormatter stringFromDate:[NSDate date]];
        patObj.toDate = [dateFormatter stringFromDate:[NSDate date]];
        prescrObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
        labOrderObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
        referralsObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
        patObj.fromDate = [dateFormatter stringFromDate:[[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:[NSDate date] options:0]];
                
        NSMutableURLRequest* request1 = [[[NSMutableURLRequest alloc] init] autorelease]; 
        NSString* url1 = [NSMutableString stringWithFormat:@"http://%@GetPharmacyOrderCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl],prescrObj.fromDate,prescrObj.toDate,[DataExchange getUserRoleId]];
        [request1 setURL:[NSURL URLWithString:url1]];
        [request1 setHTTPMethod:@"GET"];
        connPrescr = [[[NSURLConnection alloc] initWithRequest:request1 delegate:self] autorelease];
        
        NSMutableURLRequest* request2 = [[[NSMutableURLRequest alloc] init] autorelease]; 
        NSString* url2 = [NSMutableString stringWithFormat:@"http://%@GetLabOrderCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl],labOrderObj.fromDate,labOrderObj.toDate,[DataExchange getUserRoleId]];
        [request2 setURL:[NSURL URLWithString:url2]];
        [request2 setHTTPMethod:@"GET"];
        connLabOrder = [[[NSURLConnection alloc] initWithRequest:request2 delegate:self] autorelease];
        
        NSMutableURLRequest* request3 = [[[NSMutableURLRequest alloc] init] autorelease]; 
        NSString* url3 = [NSMutableString stringWithFormat:@"http://%@GetAppointmentCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl],patObj.fromDate,patObj.toDate,[DataExchange getUserRoleId]];
        [request3 setURL:[NSURL URLWithString:url3]];
        [request3 setHTTPMethod:@"GET"];
        connPatients = [[[NSURLConnection alloc] initWithRequest:request3 delegate:self] autorelease];
        
        NSMutableURLRequest* request4 = [[[NSMutableURLRequest alloc] init] autorelease]; 
        NSString* url4 = [NSMutableString stringWithFormat:@"http://%@GetReferralsCount?FromDAte=%@&Todate=%@&UserRoleId=%@",[DataExchange getbaseUrl],referralsObj.fromDate,referralsObj.toDate,[DataExchange getUserRoleId]];
        [request4 setURL:[NSURL URLWithString:url4]];
        [request4 setHTTPMethod:@"GET"];
        connReferrals = [[[NSURLConnection alloc] initWithRequest:request4 delegate:self] autorelease];
        [arrLabOrderObjMonth addObject:labOrderObj];
        [arrPatObjMonth addObject:patObj];
        [arrPrescrObjMonth addObject:prescrObj];
        [arrReferralsObjMonth addObject:referralsObj];
    }
}

@end

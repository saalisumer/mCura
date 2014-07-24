//
//  SubTenantsViewcontroller.h
//  3GMDoc
//
//  Created by Aakash Chaudhary on 09/02/12.
//  Copyright (c) 2012 aakash272@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol SubTenantsChoiceDelegate <NSObject>

-(void)subTenantChoice:(NSInteger)index;

@end

@interface SubTenantsViewcontroller : UITableViewController{
    id<SubTenantsChoiceDelegate> delegate;
}

@property(nonatomic,retain) id<SubTenantsChoiceDelegate> delegate;
@property(nonatomic,retain) NSArray* arraySubTenants;

@end

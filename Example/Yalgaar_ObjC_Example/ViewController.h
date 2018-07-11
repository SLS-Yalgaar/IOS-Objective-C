//
//  ViewController.h
//  Yalgaar_ObjC_Example
//
//  Created by Kartik Patel on 06/06/18.
//  Copyright © 2018 System Level Solutions (I) Pvt. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YalgaarClient.h"

@interface ViewController : UIViewController <YalgaarClientDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {

    YalgaarClient *objYalgaarClient;
    NSMutableArray *arrSubscribeData;
}
@end


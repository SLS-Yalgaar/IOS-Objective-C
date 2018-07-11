//
//  ViewController.m
//  Yalgaar_ObjC_Example
//
//  Created by Kartik Patel on 06/06/18.
//  Copyright © 2018 System Level Solutions (I) Pvt. Ltd. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *txtClientKey;
@property (weak, nonatomic) IBOutlet UITextField *txtUUID;
@property (weak, nonatomic) IBOutlet UIButton *btnConnect;
@property (weak, nonatomic) IBOutlet UIButton *btnDisconnect;
@property (weak, nonatomic) IBOutlet UITextField *txtChannel;
@property (weak, nonatomic) IBOutlet UIButton *btnSubscribe;
@property (weak, nonatomic) IBOutlet UIButton *btnUnsubscribe;
@property (weak, nonatomic) IBOutlet UITextField *txtmessage;
@property (weak, nonatomic) IBOutlet UIButton *btnPublish;
@property (weak, nonatomic) IBOutlet UIButton *btnClearTable;
@property (weak, nonatomic) IBOutlet UITableView *tblReceivedMessages;
@property (weak, nonatomic) IBOutlet UISegmentedControl *connectionType;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    objYalgaarClient = [[YalgaarClient alloc] init];
    objYalgaarClient.delegate = self;
    
    _txtClientKey.delegate = self;
    _txtUUID.delegate = self;
    _txtChannel.delegate = self;
    _txtmessage.delegate = self;
    
    _tblReceivedMessages.dataSource = self;
    _tblReceivedMessages.delegate = self;
    
    arrSubscribeData = [[NSMutableArray alloc] init];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma control events
- (IBAction)connectTapped:(id)sender {
    NSError* errorClientIDValidation = nil;
    
    BOOL isSecureConnection = NO;
    
    switch ([_connectionType selectedSegmentIndex]) {
        case 0:
            isSecureConnection = NO;
            break;
        case 1:
            isSecureConnection = YES;
            break;
    }
    
    if(_txtUUID.text != nil && _txtUUID.text.length > 0){
            [objYalgaarClient connectWithClientKey:_txtClientKey.text IsSecure:isSecureConnection WithUUID:_txtUUID.text Error:&errorClientIDValidation];
    } else {
            [objYalgaarClient connectWithClientKey:_txtClientKey.text IsSecure:isSecureConnection Error:&errorClientIDValidation];
    }
    
    if(errorClientIDValidation != nil){
        [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)errorClientIDValidation.code, errorClientIDValidation.userInfo]];
    }
}
- (IBAction)disconnectTapped:(id)sender {
    [objYalgaarClient disconnect];
}
- (IBAction)subscribeTapped:(id)sender {
    NSError* errorSub = nil;
    
    NSArray *arrSubChannels = [_txtChannel.text componentsSeparatedByString:@","];
    [objYalgaarClient subscribeWithChannels:arrSubChannels Error:&errorSub];
    
    if(errorSub != nil){
        [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)errorSub.code, errorSub.userInfo]];
    }
}
- (IBAction)unsubscriveTapped:(id)sender {
    NSError* errorUnSub = nil;
    
    NSArray *arrUnSubChannels = [_txtChannel.text componentsSeparatedByString:@","];
    [objYalgaarClient unsubscribeWithChannels:arrUnSubChannels Error:&errorUnSub];
    
    if(errorUnSub != nil){
        [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)errorUnSub.code, errorUnSub.userInfo]];
    }
}
- (IBAction)publishTapped:(id)sender {
    NSError* errorPubData = nil;
    
    [objYalgaarClient publishWithChannel:_txtChannel.text Message:_txtmessage.text Error:&errorPubData];
    
    if(errorPubData != nil){
        [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)errorPubData.code, errorPubData.userInfo]];
    }
}
- (IBAction)clearTapped:(id)sender {
    [arrSubscribeData removeAllObjects];
    [_tblReceivedMessages reloadData];
}
#pragma-end control events

#pragma custom methods
- (void)showErrorMessage:(NSString*) message{
    [self showMessage:message WithHeader:@"Error"];
}
- (void)showMessage:(NSString*)message WithHeader:(NSString*)header{
    
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:header message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* btnOK = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        
    }];
    [alert addAction:btnOK];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma-end custom methods

#pragma UITableView delegate methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return arrSubscribeData.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    UITextView* txtData = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width - 20, 40)];
    txtData.textAlignment = NSTextAlignmentRight;
    txtData.editable = false;
    
    txtData.text = [arrSubscribeData objectAtIndex:indexPath.row];
    
    [cell addSubview:txtData];
    
    return cell;
}
#pragma-end UITableView delegate methods

#pragma YalgaarClient delegate methods
- (void) didConnected {
    [self showMessage:@"Connected" WithHeader:@"Info"];
}
- (void) connectionAlreadyEstablished:(NSObject*)yalgaarClient {
    [self showMessage:@"Already connected" WithHeader:@"Info"];
}
- (void) connectionError:(NSError *)error {
    [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)error.code, error.userInfo]];
}
- (void) publishStatus:(BOOL)status Error:(NSError *)error {
    if(status == NO){
        [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)error.code, error.userInfo]];
    }
}
- (void) didSubscribed {
}
- (void) subscribeError:(NSError *)error {
    [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)error.code, error.userInfo]];
}
- (void) dataReceivedForSubscription:(NSString *)data OnChannels:(NSArray *)channels {
    
    NSString* receivedChannels = [channels componentsJoinedByString:@","];
    NSString* combineChannelAndData = [NSString stringWithFormat:@"Ch:%@ - data:%@",  receivedChannels, data];
    
    [arrSubscribeData addObject:combineChannelAndData];
    
    [_tblReceivedMessages reloadData];
    
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:arrSubscribeData.count-1 inSection:0];
    [_tblReceivedMessages scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void) didUnsubscribed {
}
- (void) unsubscribeError:(NSError *)error {
    [self showErrorMessage:[NSString stringWithFormat:@"%ld, %@", (long)error.code, error.userInfo]];
}
- (void) dataReceivedOfPresenceForAction:(PresenceAction)action OnChannel:(NSString *)channel UUID:(NSString*)uuid DateTime:(NSDate*)dateTime {
    
    NSString* pre = @"Bind";
    if (action == Unbind) {
        pre = @"Unbind";
    }
    
    NSString* combineChannelAndData = [NSString stringWithFormat:@"Pre = Act:%@ - Ch:%@ - UUID:%@ - T:%@", pre, channel, uuid, [NSDateFormatter localizedStringFromDate:dateTime dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
   
    [arrSubscribeData addObject:combineChannelAndData];
    
    [_tblReceivedMessages reloadData];
    
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:arrSubscribeData.count-1 inSection:0];
    [_tblReceivedMessages scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}
- (void) dataReceivedWithUUID:(NSArray*)arrUUID ForChannel:(NSString*)channel {
}
- (void) dataReceivedWithChannels:(NSArray*)arrChannels ForUUID:(NSString*)uuid {
}
- (void) getUUIDListChannelListError:(NSError *)error {
}
- (void) messageHistoryStatus:(BOOL)status Error:(NSError *)error {
}
- (void) dataReceivedForMessageHistroy:(NSArray*)data {
}
- (void) didDisconnected{
    [self showMessage:@"Disconnected" WithHeader:@"Info"];
}
- (void)allChannelsRemovedForPushNotification:(BOOL)status {
}
- (void)channelsAddedForPushNotification:(BOOL)status {
}
- (void)channelsRemovedForPushNotification:(BOOL)status {
}
#pragma-end YalgaarClient delegate methods

@end

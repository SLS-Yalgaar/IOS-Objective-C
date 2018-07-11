//
//  YalgaarClient.h
//  YalgaarDemo
//
//  Created by Kartik Patel on 22/07/2014.
//  Updated by Kartik Patel on 28/09/2016.
//  Copyright (c) 2016 System Level Solutions(I) Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AESKeyTypeNone = -1,
    AESKeyType128 = 16,
    AESKeyType192 = 24,
    AESKeyType256 = 32
} AESKeyType;

typedef enum {
    Bind,
    Unbind
} PresenceAction;

@protocol YalgaarClientDelegate <NSObject>
@required

- (void) didConnected;
- (void) connectionAlreadyEstablished:(NSObject*)yalgaarClient;
- (void) connectionError:(NSError *)error;

- (void) channelsAddedForPushNotification:(BOOL)status;
- (void) channelsRemovedForPushNotification:(BOOL)status;
- (void) allChannelsRemovedForPushNotification:(BOOL)status;

- (void) publishStatus:(BOOL)status Error:(NSError *)error;

- (void) didSubscribed;
- (void) subscribeError:(NSError *)error;
- (void) dataReceivedForSubscription:(NSString *)data OnChannels:(NSArray *)channels;

- (void) didUnsubscribed;
/*- (void) unsubscribeError:(NSError *)error;*/

- (void) dataReceivedOfPresenceForAction:(PresenceAction)action OnChannel:(NSString *)channel UUID:(NSString*)uuid DateTime:(NSDate*)dateTime;

- (void) dataReceivedWithUUID:(NSArray*)arrUUID ForChannel:(NSString*)channel;
- (void) dataReceivedWithChannels:(NSArray*)arrChannels ForUUID:(NSString*)uuid;
- (void) getUUIDListChannelListError:(NSError *)error;

- (void) messageHistoryStatus:(BOOL)status Error:(NSError *)error;
- (void) dataReceivedForMessageHistroy:(NSArray*)data;

- (void) didDisconnected;

@end

@interface YalgaarClient : NSObject {
    
}

@property (nonatomic, strong, readonly) NSString* ClientKey;
@property (nonatomic, strong, readonly) NSString* UUID;
@property (nonatomic, readonly) AESKeyType AESKeyType;

@property (nonatomic,strong) id delegate;

- (void)connectWithClientKey:(NSString*)clientKey IsSecure:(BOOL)isSecure Error:(NSError**)error;
- (void)connectWithClientKey:(NSString*)clientKey IsSecure:(BOOL)isSecure WithUUID:(NSString*)uuid Error:(NSError**)error;
- (void)connectWithClientKey:(NSString*)clientKey IsSecure:(BOOL)isSecure AESSecretKey:(NSString*)aesKey AESKeyType:(AESKeyType)keyType Error:(NSError**)error;
- (void)connectWithClientKey:(NSString*)clientKey IsSecure:(BOOL)isSecure WithUUID:(NSString*)uuid AESSecretKey:(NSString*)aesKey AESKeyType:(AESKeyType)keyType Error:(NSError**)error;

-(void)addChannelsForPushNotificationWithTokenString:(NSString*)pushNotificationTokenString WithChannels:(NSArray *)arrChanel;
-(void)removeChannelsForPushNotificationWithTokenString:(NSString*)pushNotificationTokenString WithChannels:(NSArray *)arrChanel;
-(void)removeAllChannelsForPushNotificationWithTokenString:(NSString*)pushNotificationTokenString;

- (void)subscribeWithChannel:(NSString*)channel Error:(NSError**)error;
- (void)subscribeWithChannels:(NSArray*)channels Error:(NSError**)error;

- (void)publishWithChannel:(NSString*)channel Message:(NSString*)message Error:(NSError**)error;

- (void)unsubscribeWithChannel:(NSString*)channel Error:(NSError**)error;
- (void)unsubscribeWithChannels:(NSArray*)channels Error:(NSError**)error;

- (void)messageHistoryWithChannel:(NSString*)channel Count:(int)messageCount Error:(NSError**)error;

- (void)getChannelListForUUID:(NSString*)uuid Error:(NSError**)error;

- (void)getUUIDListForChannel:(NSString*)channel Error:(NSError**)error;

- (void)disconnect;

@end

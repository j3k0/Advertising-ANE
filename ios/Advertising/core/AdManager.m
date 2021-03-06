//
//  AdManager.m
//  Advertisting
//
//  Created by Tsang Wai Lam on 25/8/14.
//
//

#import "AdManager.h"

#if ENABLE_IAD
#import "IAdBannerAdapter.h"
#import "IAdInterstitialAdapter.h"
#endif

#if ENABLE_ADMOB
#import "AdmobBannerAdapter.h"
#import "AdmobInterstitialAdapter.h"
#endif

#if ENABLE_AMAZON
#import "AmazonBannerAdapter.h"
#import "AmazonInterstitialAdapter.h"
#endif

#if ENABLE_INMOBI
#import "InMobiBannerAdapter.h"
#import "InMobiInterstitialAdapter.h"
#endif

#import "MMBannerAdapter.h"
#import "MMInterstitialAdapter.h"

#import "BackFillBannerAdapter.h"
#import "BackFillInterstitialAdapter.h"


@implementation AdManager

@synthesize testMode=testMode_;
@synthesize rootController=rootController_;
@synthesize adapterIndex=adapterIndex_;
@synthesize cleanAdapterIndex=cleanAdapterIndex_;
@synthesize lastAdapter=lastAdapter_;
@synthesize callback=callback_;

- (void) dealloc {
    
    self.rootController=nil;
    self.adapterIndex=nil;
    self.cleanAdapterIndex=nil;
    
    [super dealloc];
}

- (id) initWithContiner:(UIViewController*)controller {
    if (self=[self init]) {                
        
        self.rootController=controller;
        self.adapterIndex=[[NSMutableDictionary alloc] init];
        self.cleanAdapterIndex=[[NSMutableDictionary alloc] init];
        
    }
    return self;
}

//- (void) create:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId settings:(NSDictionary*)settings{
//    
//    NSLog(@"AdManager create id:%@ size:%@ network:%@",uid,size,network);
//
//    // check if uid exist
//    if([adapterIndex_ objectForKey:uid]==nil){
//
//        // create adapter
//        AbstractAdAdapter *adapter = [self createAdAdapter:uid size:size network:network adUnitId:adUnitId settings:settings];
//        
//        // put adpater in the index
//        [adapterIndex_ setObject:adapter forKey:uid];
//        
//        // load the ads
//        [adapter refresh];
//    }
//    
//}

- (AbstractAdAdapter*) load:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId setting:(NSDictionary*)settings
{
//    NSLog(@"AdManager load: %@ network: %@", uid, network);
    
    AbstractAdAdapter *adapter = [adapterIndex_ objectForKey:uid];
    
    // Check if the id exist
    if(adapter){
        
//        NSLog(@"adapter exist %@ %@", [adapter getNetworkType], network);
        
        if([[adapter getNetworkType] isEqualToString:network]){
            
            if([size isEqualToString:kAdAdapterSizeINTERSTITIAL])
                [adapter load:settings];
            
        } else {

            // check if last adapter ready
            if (adapter.ready) {
                
//                // remove old adapter
//                AbstractAdAdapter *old_adapter = [cleanAdapterIndex_ objectForKey:uid];
//                if(old_adapter){
//                    [old_adapter remove];
//                    [old_adapter destroy];
//                    [adapterIndex_ removeObjectForKey:uid];
//                }
                
                // add current adapter to clean list
                [cleanAdapterIndex_ setObject:adapter forKey:uid];
                
            } else {

                // clean not ready adapter
                [adapter remove];
                [adapter destroy];
                [adapterIndex_ removeObjectForKey:uid];
            }
            
            // create new adapter
            adapter = [self createAdAdapter:uid size:size network:network adUnitId:adUnitId settings:settings];
                        
            if(adapter){
                
                // put adpater in the index
                [adapterIndex_ setObject:adapter forKey:uid];
                
                // refresh the ad
                [adapter load:settings];
                
            } else {
                
            }
            
        }
        
    } else {
        
        // create adapter
        adapter = [self createAdAdapter:uid size:size network:network adUnitId:adUnitId settings:settings];
        
        // put adpater in the index
        [adapterIndex_ setObject:adapter forKey:uid];
        
        // refresh the ad
        [adapter load:settings];
        
    }
   
    return adapter;
}

- (void) show:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId setting:(NSDictionary*)settings position:(NSString*) position x:(int)x y:(int)y{

    NSLog(@"AdManager show: %@ network: %@ position: %@ x:%d y:%d", uid, network, position,x,y);

    // load the ad
    AbstractAdAdapter *adapter = [self load:uid size:size network:network adUnitId:adUnitId setting:settings];
    
    // assign root controller
    adapter.rootController=rootController_;
    
    // show the ads
    [adapter showInPosition:position offsetX:x offsetY:y];
}

- (void) remove:(NSString*)uid{

    NSLog(@"AdManager remove: %@", uid);
    
    AbstractAdAdapter *adapter = [adapterIndex_ objectForKey:uid];
    
    if(adapter){
        [adapter remove];
    }
}

- (void) pause:(NSString*)uid{
    
//    NSLog(@"AdManager pause: %@", uid);
    
    AbstractAdAdapter *adapter = [adapterIndex_ objectForKey:uid];
    
    if(adapter){
        [adapter pause];
    }
    
}

- (void) resume:(NSString*)uid{
    
//    NSLog(@"AdManager resume: %@", uid);
    
    AbstractAdAdapter *adapter = [adapterIndex_ objectForKey:uid];
    
    if(adapter){
        [adapter resume];
    }
    
}

- (void) destroy:(NSString*)uid
{
    
//    NSLog(@"AdManager show: %@", uid);
//    
//    AbstractAdAdapter *adapter = [bannerIndex_ objectForKey:uid];
//    
//    if(adapter){
//        [adapter remove];
//    }
    
}

#pragma mark - Helper

- (AbstractAdAdapter*) createAdAdapter:(NSString*)uid size:(NSString*) size network:(NSString*) network adUnitId:(NSString*)adUnitId settings:(NSDictionary*) settings
{
    if(settings==nil) return nil;
    
    // define
    AbstractAdAdapter *adapter = nil;
    
//    // get adunit id
//    NSString *adUnitId = [settings objectForKey:@"adUnitId"];
    
    // create different Adapater
    if([size isEqualToString:kAdAdapterSizeINTERSTITIAL]){
        
        if (NO) {
        }
#if ENABLE_ADMOB
        else if([network isEqualToString:kNetworkTypeADMOB]){
           
            adapter = [[AdmobInterstitialAdapter alloc] initWithAdUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_AMAZON
        else if([network isEqualToString:kNetworkTypeAMAZON]){

            adapter = [[AmazonInterstitialAdapter alloc] initWithAdUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_IAD
        else if([network isEqualToString:kNetworkTypeIAD]){

            adapter = [[IAdInterstitialAdapter alloc] initWithSettings:settings];
            
        }
#endif
#if ENABLE_MM_INTERSTITIAL
        else if([network isEqualToString:kNetworkTypeMILLENNIALMEDIA]){
            
            adapter = [[MMInterstitialAdapter alloc] initWithAdUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_INMOBI
else if([network isEqualToString:kNetworkTypeINMOBI]){
            
            adapter = [[InMobiInterstitialAdapter alloc] initWithAdUnitId:adUnitId settings:settings];
            
        }
#endif
        else if([network isEqualToString:kNetworkTypeBACKFILL]){
            
            adapter = [[BackFillInterstitialAdapter alloc] initWithLink:adUnitId settings:settings];
            
        }
    } else {
        if (NO) {
        }
#if ENABLE_ADMOB
        else if([network isEqualToString:kNetworkTypeADMOB]){
            
            adapter = [[AdmobBannerAdapter alloc] initWithSize:size adUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_AMAZON
        else if([network isEqualToString:kNetworkTypeAMAZON]){
            
            adapter = [[AmazonBannerAdapter alloc] initWithSize:size adUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_IAD
        else if([network isEqualToString:kNetworkTypeIAD]){
            
            adapter = [[IAdBannerAdapter alloc] initWithSize:size settings:settings];
            
        }
#endif
#if ENABLE_MM_BANNER
        else if([network isEqualToString:kNetworkTypeMILLENNIALMEDIA]){
            
            adapter = [[MMBannerAdapter alloc] initWithSize:size adUnitId:adUnitId settings:settings];
            
        }
#endif
#if ENABLE_INMOBI
        else if([network isEqualToString:kNetworkTypeINMOBI]){
            
            adapter = [[InMobiBannerAdapter alloc] initWithSize:size adUnitId:adUnitId settings:settings];
            
        }
#endif
        else if([network isEqualToString:kNetworkTypeBACKFILL]){
            
            adapter = [[BackFillBannerAdapter alloc] initWithSize:size link:adUnitId settings:settings];
        }
    }
    
    if(adapter){
        adapter.uid=uid;
        adapter.rootController=rootController_;
        adapter.testMode=testMode_;
        adapter.size=size;
        adapter.delegate=self;
    }
    
    return adapter;
}

#pragma mark - Helper

-(NSString *)escapeString:(NSString *)aString {
    NSMutableString *s = [NSMutableString stringWithString:aString];
    [s replaceOccurrencesOfString:@"\"" withString:@" " options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"/" withString:@"\\/" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\n" withString:@"\\n" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\b" withString:@"\\b" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\f" withString:@"\\f" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\r" withString:@"\\r" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    [s replaceOccurrencesOfString:@"\t" withString:@"\\t" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [s length])];
    return [NSString stringWithString:s];
}

-(NSString *)buildEventWithUid:(NSString *)uid size:(NSString *)size network:(NSString *)network error:(NSString *)error {
    
    // if error
    if(error)
        return [NSString stringWithFormat:@"{\"uid\":\"%@\",\"size\":\"%@\",\"network\":\"%@\",\"error\":\"%@\"}",uid,size,network,[self escapeString:error]];
    
    return [NSString stringWithFormat:@"{\"uid\":\"%@\",\"size\":\"%@\",\"network\":\"%@\"}",uid,size,network];
}

#pragma mark - AdAdapterDelegate

- (void)adLog:(NSString*)msg
{
    if(callback_) callback_(@"LOGGING", msg);
}

- (void)adAdapterDidReceiveAd:(AbstractAdAdapter *)adapter{
    
    // remove old adapter
    AbstractAdAdapter *old_adapter = [cleanAdapterIndex_ objectForKey:adapter.uid];
    if(old_adapter){
        [old_adapter remove];
        [old_adapter destroy];
        [cleanAdapterIndex_ removeObjectForKey:adapter.uid];
    }
    
    if(callback_) callback_(@"onAdLoaded", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}
- (void)adAdapter:(AbstractAdAdapter *)adapter didFailToReceiveAdWithError:(NSString *)error{
    if(callback_) callback_(@"onAdFailedToLoad", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:[self escapeString:error]]);
}
- (void)adAdapterWillPresent:(AbstractAdAdapter *)adapter{
    if(callback_) callback_(@"onAdWillPresent", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}
- (void)adAdapterDidPresent:(AbstractAdAdapter *)adapter{
    if(callback_) callback_(@"onAdDidPresent", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}
- (void)adAdapterDidDismiss:(AbstractAdAdapter*)adapter{
    if(callback_) callback_(@"onAdDidDismiss", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}
- (void)adAdapterWillDismiss:(AbstractAdAdapter *)adapter{
    if(callback_) callback_(@"onAdWillDismiss", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}
- (void)adAdapterWillLeaveApplication:(AbstractAdAdapter*)adapter{
    if(callback_) callback_(@"onWillLeaveApplication", [self buildEventWithUid:adapter.uid size:adapter.size network:adapter.getNetworkType error:nil]);
}

@end

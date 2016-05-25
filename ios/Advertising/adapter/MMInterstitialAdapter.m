//
//  MMInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#if ENABLE_MM_INTERSTITIAL

#import "MMInterstitialAdapter.h"

@implementation MMInterstitialAdapter

@synthesize mmInterstitialAd = mmInterstitialAd_;

static NSString* MMSDKinited = nil;

- (void) destroy{
    /*
    // Notification will fire when an ad causes the application to terminate or enter the background
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdWillTerminateApplication object:nil];
    
    // Notification will fire when an ad is tapped.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdWasTapped object:nil];
    
    // Notification will fire when an ad modal will appear.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalWillAppear object:nil];
    
    // Notification will fire when an ad modal did appear.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalDidAppear object:nil];
    
    // Notification will fire when an ad modal will dismiss.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalWillDismiss object:nil];

    // Notification will fire when an ad modal did dismiss.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MillennialMediaAdModalDidDismiss object:nil];
    */
    
    if (self.mmInterstitialAd) {
        self.mmInterstitialAd.delegate = nil;
        self.mmInterstitialAd = nil;
    }
    [super destroy];
}

- (void) dealloc {
    if (self.mmInterstitialAd) {
        self.mmInterstitialAd.delegate = nil;
        self.mmInterstitialAd = nil;
    }
    [super dealloc];
}

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings
{
    self = [self init];
    if (self != nil) {
            
        self.adUnitId=adUnitId;
        if(![MMSDK sharedInstance].isInitialized) {
            /*self.locationManager = [[CLLocationManager alloc] init];
            // Check for iOS 8. Without this guard the code will crash with "unknown selector" on iOS 7.
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }*/
            NSLog(@"[AdvertisingANE::MMInterstitialAdapter] Initialize MMSDK");
            MMSDKinited=@"i";
            [MMSDK setLogLevel:MMLogLevelDebug];
            MMAppSettings* appSettings=[[MMAppSettings alloc] init];
            MMUserSettings* userSettings=nil;
            [[MMSDK sharedInstance] initializeWithSettings:appSettings withUserSettings:userSettings];
        }
        self->isNeedToShow_=false;

        NSLog(@"[AdvertisingANE::MMInterstitialAdapter] Create MMInterstitialAd %@", adUnitId);
        self.mmInterstitialAd = [[MMInterstitialAd alloc] initWithPlacementId:adUnitId];
        self.mmInterstitialAd.delegate = self;
        
        /*
        // Notification will fire when an ad causes the application to terminate or enter the background
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationWillTerminateFromAd:)
                                                     name:MillennialMediaAdWillTerminateApplication
                                                   object:nil];
        
        // Notification will fire when an ad is tapped.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adWasTapped:)
                                                     name:MillennialMediaAdWasTapped
                                                   object:nil];
        
        // Notification will fire when an ad modal will appear.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalWillAppear:)
                                                     name:MillennialMediaAdModalWillAppear
                                                   object:nil];
        
        // Notification will fire when an ad modal did appear.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalDidAppear:)
                                                     name:MillennialMediaAdModalDidAppear
                                                   object:nil];
        
        // Notification will fire when an ad modal will dismiss.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalWillDismiss:)
                                                     name:MillennialMediaAdModalWillDismiss
                                                   object:nil];
        
        // Notification will fire when an ad modal did dismiss.
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(adModalDidDismiss:)
                                                     name:MillennialMediaAdModalDidDismiss
                                                   object:nil];
         */

    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {

    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] Showing MMInterstitialAd");
    if (self.mmInterstitialAd.ready) {
        [self.mmInterstitialAd showFromViewController:rootController_];
    }
    else {
        if (self.mmInterstitialAd.expired) {
            NSLog(@"[AdvertisingANE::MMInterstitialAdapter] MMInterstitialAd expired => reloading");
            [self.mmInterstitialAd load:nil];
        }
        self->isNeedToShow_=YES;
    }
/*
        NSLog(@"show interstitial %@ %d", adUnitId_, [MMInterstitial isAdAvailableForApid:adUnitId_]);
    
        // check if interstitial ready
        if (cached_||[MMInterstitial isAdAvailableForApid:adUnitId_]) {
            cached_=NO;
            [MMInterstitial displayForApid:adUnitId_
                        fromViewController:rootController_
                           withOrientation:MMOverlayOrientationTypeAll
                              onCompletion:^(BOOL success, NSError *error) {
                                  if(success){
//                                      [delegate_ adAdapterWillPresent:self];
//                                      [delegate_ adAdapterDidPresent:self];
                                  }
                              }];
            
        } else {
            isNeedToShow_=YES;
        }
*/
}

- (void) remove{

}

- (void) load:(NSDictionary*)settings {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] load");
    if(!self.mmInterstitialAd.ready) {
        NSLog(@"[AdvertisingANE::MMInterstitialAdapter] not ready => loading");
        [self.mmInterstitialAd load:nil];
    }
    /*
    if(![MMInterstitial isAdAvailableForApid:adUnitId_]){

        //MMRequest Object
        MMRequest *request = [MMRequest request];
        
        // Set extra parameters
        NSString *age=[settings objectForKey:@"age"];
        if(age)
            request.age=[NSNumber numberWithInt:[age intValue]];

        //Replace YOUR_APID with the APID provided to you by Millennial Media
        [MMInterstitial fetchWithRequest:request
                                    apid:adUnitId_
                            onCompletion:^(BOOL success, NSError *error) {
                                if (success) {
                                    [delegate_ adAdapterDidReceiveAd:self];
                                    if(isNeedToShow_){
                                        isNeedToShow_=NO;
                                        [MMInterstitial displayForApid:adUnitId_
                                                    fromViewController:rootController_
                                                       withOrientation:MMOverlayOrientationTypeAll
                                                          onCompletion:^(BOOL success, NSError *error) {
                                                              if(success){
//                                                                  [delegate_ adAdapterWillPresent:self];
//                                                                  [delegate_ adAdapterDidPresent:self];
                                                              }
                                                          }];
                                    } else {
                                        cached_=YES;
                                    }
                                }
                                else {
                                    if ([error.description rangeOfString:@"already cached"].location == NSNotFound) {
                                        [delegate_ adAdapter:self didFailToReceiveAdWithError:error.description];
                                    } else {
                                        [delegate_ adAdapterDidReceiveAd:self];
                                        if(isNeedToShow_){
                                            isNeedToShow_=NO;
                                            [MMInterstitial displayForApid:adUnitId_
                                                        fromViewController:rootController_
                                                           withOrientation:MMOverlayOrientationTypeAll
                                                              onCompletion:^(BOOL success, NSError *error) {
                                                                  if(success){
//                                                                      [delegate_ adAdapterWillPresent:self];
//                                                                      [delegate_ adAdapterDidPresent:self];
                                                                  }
                                                              }];
                                        } else {
                                            cached_=YES;
                                        }
                                    }
                                }
                            }];
    }
    */
}

- (NSString*) getNetworkType{
    return kNetworkTypeMILLENNIALMEDIA;
}

#pragma MMInterstitialDelegate

/**
 * Callback fired when an ad load (request and content processing) succeeds.
 *
 * This method is always invoked on the main thread.
 *
 * @param ad The ad placement which was successfully requested.
 */
-(void)interstitialAdLoadDidSucceed:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdLoadDidSucceed");
    if(self->isNeedToShow_){
        NSLog(@"[AdvertisingANE::MMInterstitialAdapter] isNeedToShow -> showing");
        [self.mmInterstitialAd showFromViewController:rootController_];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

/**
 * Callback fired when an ad load fails. The failure can be caused by failure to either retrieve or parse
 * ad content.
 *
 * This method is always invoked on the main thread.
 *
 * @param ad The ad placement for which the request failed.
 * @param error The error indicating the failure.
 */
-(void)interstitialAd:(MMInterstitialAd*)ad loadDidFailWithError:(NSError*)error {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] loadDidFailWithError:%@", error);
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.localizedDescription];
}

/**
 *  Callback fired when an interstitial will be displayed, but before the display action begins.
 *  Note that the ad could still fail to display at this point.
 *
 * This method is always called on the main thread.
 *
 *  @param ad The interstitial which will display.
 */
-(void)interstitialAdWillDisplay:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdWillDisplay");
    [delegate_ adAdapterWillPresent:self];
}

/**
 * Callback fired when the interstitial is displayed.
 *
 * This method is always called on the main thread.
 *
 * @param ad The interstitial which is displayed.
 */
-(void)interstitialAdDidDisplay:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdDidDisplay");
    [delegate_ adAdapterDidPresent:self];
}

/**
 * Callback fired when an attempt to show the interstitial fails.
 *
 * This method is always called on the main thread.
 *
 * @param ad The interstitial which failed to show.
 * @param error The error indicating the failure.
 */
-(void)interstitialAd:(MMInterstitialAd*)ad showDidFailWithError:(NSError*)error {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAd:showDidFailWithError");
}

/**
 * Callback fired when an interstitial will be dismissed, but before the dismiss action begins.
 *
 * This method is always called on the main thread.
 *
 *  @param ad The interstitial which will be dismissed.
 */
-(void)interstitialAdWillDismiss:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdWillDismiss");
    [delegate_ adAdapterWillDismiss:self];
}

/**
 * Callback fired when the interstitial is dismissed.
 *
 * This method is always called on the main thread.
 *
 * @param ad The interstitial which was dismissed.
 */
-(void)interstitialAdDidDismiss:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdDidDismiss");
    [delegate_ adAdapterDidDismiss:self];
}

/**
 * Callback fired when the ad expires.
 *
 * After receiving this message, your app should call -load before attempting to display the interstitial.
 *
 * This method is always called on the main thread.
 *
 * @param ad The ad placement which expired.
 */
-(void)interstitialAdDidExpire:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdDidExpire");
}

/**
 * Callback fired when the ad is tapped.
 *
 * This method is always called on the main thread.
 *
 * @param ad The ad placement which was tapped.
 */
-(void)interstitialAdTapped:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdTapped");
}

/**
 * Callback invoked prior to the application going into the background due to a user interaction with an ad.
 *
 * This method is always called on the main thread.
 *
 * @param ad The ad placement.
 */
-(void)interstitialAdWillLeaveApplication:(MMInterstitialAd*)ad {
    NSLog(@"[AdvertisingANE::MMInterstitialAdapter] interstitialAdWillLeaveApplication");
    [delegate_ adAdapterWillLeaveApplication:self];
}

/*
#pragma mark - Millennial Media Notification Methods

- (void)adWasTapped:(NSNotification *)notification {
//    NSLog(@"AD WAS TAPPED");
//    NSLog(@"TAPPED AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"TAPPED AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"TAPPED AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    
//    if ([[notification userInfo] objectForKey:MillennialMediaAdObjectKey] == _bannerAdView) {
//        NSLog(@"TAPPED AD IS THE _bannerAdView INSTANCE VARIABLE");
//    }
}

- (void)applicationWillTerminateFromAd:(NSNotification *)notification {
//    NSLog(@"AD WILL OPEN SAFARI");
    // No User Info is passed for this notification
    [delegate_ adAdapterWillLeaveApplication:self];
}

- (void)adModalWillDismiss:(NSNotification *)notification {
//    NSLog(@"AD MODAL WILL DISMISS");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterWillDismiss:self];
}

- (void)adModalDidDismiss:(NSNotification *)notification {
//    NSLog(@"AD MODAL DID DISMISS");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterDidDismiss:self];
}

- (void)adModalWillAppear:(NSNotification *)notification {
//    NSLog(@"AD MODAL WILL APPEAR");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterWillPresent:self];
}

- (void)adModalDidAppear:(NSNotification *)notification {
//    NSLog(@"AD MODAL DID APPEAR");
//    NSLog(@"AD IS TYPE %@", [[notification userInfo] objectForKey:MillennialMediaAdTypeKey]);
//    NSLog(@"AD APID IS %@", [[notification userInfo] objectForKey:MillennialMediaAPIDKey]);
//    NSLog(@"AD IS OBJECT %@", [[notification userInfo] objectForKey:MillennialMediaAdObjectKey]);
    [delegate_ adAdapterDidPresent:self];
}
*/
@end

#endif
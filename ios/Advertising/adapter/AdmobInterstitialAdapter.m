//
//  AdmobInterstitialAdapter.m
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#import "AdmobInterstitialAdapter.h"

@implementation AdmobInterstitialAdapter
@synthesize adView=adView_;

- (void) dealloc {
    
    adView_.delegate=nil;
    self.adView=nil;

    viewController_ = nil;
    
    [super dealloc];
}

- (void) destroy {
    
    adView_.delegate=nil;
    self.adView=nil;
    
    [super destroy];
}


- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings{
    
    if (self=[self init]) {
        if(adView_==nil){
            
            self.adView = [[GADInterstitial alloc] init];
            self.adUnitId=adUnitId;
            adView_.adUnitID=adUnitId;
            adView_.delegate=self;
        }
    }
    return self;
}

- (void) showInPosition:(NSString*) position offsetX: (int) x offsetY:(int) y {
    if(adView_){
        if(adView_.isReady){
            [self presentAd];
        } else {
            isNeedToShow_=YES;
        }
    }
}

- (void) remove{
//    if(adView_){
//        [adView_ removeFromSuperview];
//    }
}

- (void) load:(NSDictionary*)settings {
    
    if(adView_){
        
        NSLog(@"adapter refresh %d", [adView_ hasBeenUsed]);
        
        // check if already used and clean
        if([adView_ hasBeenUsed]){
            
            // clean current interstitial
            adView_.delegate=nil;
            self.adView=nil;
            
            // creat a new one
            self.adView = [[GADInterstitial alloc] init];
            adView_.adUnitID=adUnitId_;
            adView_.delegate=self;
            
        }
        
        GADRequest *request = [GADRequest request];
        
        if(testMode_){
            
            // get device ID;
            NSString *deviceID=[self admobDeviceID_];
            
            NSLog(@"Test Mode %@", deviceID);
            // create arary to hold test device
            NSMutableArray *testDevices=[NSMutableArray array];

            // Enable test ads on simulators.
            // [testDevices addObject:GAD_SIMULATOR_ID];
            [testDevices addObject:deviceID];

            // set the test devices
            request.testDevices = testDevices;
//            request.testDevices = @[deviceID];
        }
        
        // load the request
        [self.adView loadRequest:request];
    }
}

- (NSString*) getNetworkType{
    return kNetworkTypeADMOB;
}

- (void)presentAd
{
    if (!viewController_) {
        viewController_ = [[UIViewController alloc] initWithNibName:nil bundle:nil];
        CGRect  viewRect = [[UIScreen mainScreen] bounds];
        /*CGRectMake(0, 0,
            [[UIScreen mainScreen] applicationFrame].size.width,
            [[UIScreen mainScreen] applicationFrame].size.height);*/
        // CGRectMake(0, 0, 1136/2, 640/2);
        UIView* myView = [[UIView alloc] initWithFrame:viewRect];
        viewController_.view = myView;
        viewController_.modalPresentationStyle = UIModalPresentationOverFullScreen;
        viewController_.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    }
    // TODO: Create an inner view.
    //       With a view controller that checks the orientation.
    //       Present the ad inside this view controller.
    // [rootController_ presentViewController:viewController_ animated:NO completion:nil];
    oldViewController_ = rootController_.presentedViewController;
    if (rootController_.presentedViewController != nil) {
        NSLog(@"Presented view controller saved.");
    }
    [rootController_ presentViewController:viewController_ animated:NO completion:^{
        [adView_ presentFromRootViewController:viewController_];
    }];
    
    // [adView_ presentFromRootViewController:rootController_];
}

#pragma mark - GADBannerViewDelegate

- (void)interstitialDidReceiveAd:(GADInterstitial *)interstitial
{
    if(isNeedToShow_){
        isNeedToShow_=NO;
        [self presentAd];
    }
    [delegate_ adAdapterDidReceiveAd:self];
}

- (void)interstitial:(GADInterstitial *)interstitial didFailToReceiveAdWithError:(GADRequestError *)error
{
    [delegate_ adAdapter:self didFailToReceiveAdWithError:error.debugDescription];    
}
- (void)interstitialWillPresentScreen:(GADInterstitial *)interstitial{
    [delegate_ adAdapterWillPresent:self];
    [delegate_ adAdapterDidPresent:self];
}
- (void)interstitialWillDismissScreen:(GADInterstitial *)interstitial
{
    [delegate_ adAdapterWillDismiss:self];
}
- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial
{
    [delegate_ adAdapterDidDismiss:self];
    // TODO: Delete the view controller.
    // [viewController_ presentViewController:rootController_ animated:NO completion:nil];
    [rootController_ dismissViewControllerAnimated:NO completion:nil];
    if (oldViewController_ != nil) {
        [rootController_ presentViewController:oldViewController_ animated:NO];
    }
    rootController_.view.translatesAutoresizingMaskIntoConstraints = YES;
}
- (void)interstitialWillLeaveApplication:(GADInterstitial *)interstitial
{
    NSLog(@"interstitialWillLeaveApplication");
    [delegate_ adAdapterWillLeaveApplication:self];
}


@end

//
//  AdmobInterstitialAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 31/8/14.
//
//

#import "AbstractAdAdapter.h"
#import <GoogleMobileAds/GADInterstitial.h>

@interface AdmobInterstitialAdapter : AbstractAdAdapter <GADInterstitialDelegate>{
    
    GADInterstitial* adView_;    
    UIViewController* viewController_;
    UIViewController* oldViewController_;
}
@property (nonatomic, retain) GADInterstitial* adView;

- (id) initWithAdUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;

@end

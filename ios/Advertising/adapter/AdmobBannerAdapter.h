//
//  AdmobBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 29/8/14.
//
//

#if ENABLE_ADMOB

#import "AbstractAdAdapter.h"
#import <GoogleMobileAds/GADBannerView.h>
#import <GoogleMobileAds/GADRequest.h>

@class GADBannerView;

@interface AdmobBannerAdapter : AbstractAdAdapter <GADBannerViewDelegate>{
    
    GADBannerView* adView_;    
    
}
@property (nonatomic, retain) GADBannerView* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;
    
@end

#endif
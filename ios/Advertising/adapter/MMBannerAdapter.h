//
//  MMBannerAdapter.h
//  Advertising
//
//  Created by Tsang Wai Lam on 7/9/14.
//
//

#import "AbstractAdAdapter.h"
#import <MMAdSDK/MMSDK.h>
#import <MMAdSDK/MMAdView.h>
#import <MMAdSDK/MMRequest.h>

@interface MMBannerAdapter : AbstractAdAdapter {
    
    MMAdView* adView_;
    
}
@property (nonatomic, retain) MMAdView* adView;

- (id) initWithSize:(NSString*)size adUnitId:(NSString*) adUnitId settings:(NSDictionary*) settings;


@end

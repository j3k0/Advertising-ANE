package digicrafts.extensions.adapter;

import android.app.Activity;
import android.os.Handler;
import android.os.Looper;

import com.google.android.gms.ads.MobileAds;
import com.google.android.gms.ads.initialization.InitializationStatus;
import com.google.android.gms.ads.initialization.OnInitializationCompleteListener;

import digicrafts.extensions.AdvertisingContext;

import java.lang.Runnable;
import java.util.ArrayList;

public class Admob {

    private static InitializationStatus status = null;
    private static Boolean initializing = false;
    private static Boolean initialized = false;
    private static ArrayList<OnInitializationCompleteListener> listeners = new ArrayList<OnInitializationCompleteListener>();

    public static void initialize(final AdvertisingContext context, final Activity activity, final OnInitializationCompleteListener listener) {
        if (Admob.initialized) {
            if (listener != null) {
                listener.onInitializationComplete(Admob.status);
            }
            return;
        }
        if (listener != null) {
            listeners.add(listener);
        }
        if (Admob.initializing) {
            return;
        }
        Admob.initializing = true;
        Admob.initialized = false;
        context.log("[Admob] initialize()");
        // Get a handler that can be used to post to the main thread
        Handler mainHandler = new Handler(Looper.getMainLooper());
        mainHandler.post(new Runnable() {
            @Override 
            public void run() {
                MobileAds.initialize(activity, new OnInitializationCompleteListener() {
                    @Override
                    public void onInitializationComplete(InitializationStatus initializationStatus) {
                        context.log("[Admob] onInitializationComplete()");
                        Admob.status = initializationStatus;
                        Admob.initializing = false;
                        Admob.initialized = true;
                        ArrayList<OnInitializationCompleteListener> copy = listeners;
                        listeners = new ArrayList<OnInitializationCompleteListener>();
                        for (int i = 0; i < copy.size(); i++) {
                            copy.get(i).onInitializationComplete(initializationStatus);
                        }
                    }
                });
            }
        });
    }
}

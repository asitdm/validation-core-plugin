//
//  ValidationCorePlugin.m
//  App
//
//  Created by Dominik Mocher on 30.06.21.
//

#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

CAP_PLUGIN(ValidationCorePlugin, "ValidationCorePlugin",
           CAP_PLUGIN_METHOD(setup, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(validate, CAPPluginReturnPromise);
)

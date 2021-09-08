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
           CAP_PLUGIN_METHOD(setupTrustlist, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setupBusinessRuleService, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(setupValueSetService, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(validate, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(updateTrustlist, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(updateBusinessRules, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(updateValueSet, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(decodeBusinessRules, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(decodeValueSet, CAPPluginReturnPromise);
)

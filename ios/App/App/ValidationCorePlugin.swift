//
//  ValidationCorePlugin.swift
//  App
//
//  Created by Dominik Mocher on 30.06.21.
//

import Foundation
import ValidationCore
import DccCachingService
import Capacitor

@objc(ValidationCorePlugin)
public class ValidationCorePlugin: CAPPlugin {
    private var dccCachingService = DccCachingService()
    private lazy var validationCore : ValidationCore = ValidationCore(trustlistService: dccCachingService.trustlistService)
    
    @objc func setup(_ call: CAPPluginCall) {
        let trustlistUrl = call.getString("trustlistUrl")
        let signatureUrl = call.getString("signatureUrl")
        let trustAnchor = call.getString("trustAnchor")
        let trustlistApiKey = call.getString("trustlistApiKey")
        let encryptTrustlist = call.getBool("encryptTrustlist", false)
        
        let businessRulesUrl = call.getString("businessRulesUrl")
        let businessRulesSignatureUrl = call.getString("businessRulesSignatureUrl")
        let businessRulesTrustAnchor = call.getString("businessRulesTrustAnchor")
        let businessRulesApiKey = call.getString("businessRulesApiKey")
        let encryptBusinessRules = call.getBool("encryptBusinessRules", false)
        
        let valueSetUrl = call.getString("valueSetUrl")
        let valueSetSignatureUrl = call.getString("valueSetSignatureUrl")
        let valueSetTrustAnchor = call.getString("valueSetTrustAnchor")
        let valueSetApiKey = call.getString("valueSetApiKey")
        let encryptValueSet = call.getBool("encryptValueSet", false)
        
        dccCachingService = DccCachingService(dateService: nil, trustlistUrl: trustlistUrl, trustlistSignatureUrl: signatureUrl, trustlistTrustAnchor: trustAnchor, trustlistApiKey: trustlistApiKey, encryptTrustlist: encryptTrustlist,
                                              businessRulesUrl: businessRulesUrl, businessRulesSignatureUrl: businessRulesSignatureUrl, businessRulesTrustAnchor: businessRulesTrustAnchor, businessRulesApiKey: businessRulesApiKey, encryptBusinessRules: encryptBusinessRules,
                                              valueSetUrl: valueSetUrl, valueSetSignatureUrl: valueSetSignatureUrl, valueSetTrustAnchor: valueSetTrustAnchor, valueSetApiKey: valueSetApiKey, encryptValueSet: encryptValueSet)
        validationCore = ValidationCore(trustlistService: dccCachingService.trustlistService)
    }
    
    @objc func setupTrustlist(_ call: CAPPluginCall) {
        let trustlistUrl = call.getString("trustlistUrl")
        let signatureUrl = call.getString("signatureUrl")
        let trustAnchor = call.getString("trustAnchor")
        let trustlistApiKey = call.getString("trustlistApiKey")
        let encryptTrustlist = call.getBool("encryptTrustlist", false)
        
        dccCachingService.initTrustlistService(trustlistUrl: trustlistUrl, signatureUrl: signatureUrl, trustAnchor: trustAnchor, apiKey: trustlistApiKey, dateService: nil, storeEncrypted: encryptTrustlist)
        validationCore = ValidationCore(trustlistService: dccCachingService.trustlistService)
    }
    
    @objc func setupBusinessRuleService(_ call: CAPPluginCall) {
        let businessRulesUrl = call.getString("businessRulesUrl")
        let businessRulesSignatureUrl = call.getString("businessRulesSignatureUrl")
        let businessRulesTrustAnchor = call.getString("businessRulesTrustAnchor")
        let businessRulesApiKey = call.getString("businessRulesApiKey")
        let encryptBusinessRules = call.getBool("encryptBusinessRules", false)
        
        dccCachingService.initBusinessRuleService(businessRulesUrl: businessRulesUrl, signatureUrl: businessRulesSignatureUrl, trustAnchor: businessRulesTrustAnchor, apiKey: businessRulesApiKey, dateService: nil, storeEncrypted: encryptBusinessRules)
    }
    
    @objc func setupValueSetService(_ call: CAPPluginCall) {
        let valueSetUrl = call.getString("valueSetUrl")
        let valueSetSignatureUrl = call.getString("valueSetSignatureUrl")
        let valueSetTrustAnchor = call.getString("valueSetTrustAnchor")
        let valueSetApiKey = call.getString("valueSetApiKey")
        let encryptValueSet = call.getBool("encryptValueSet", false)
        
        dccCachingService.initValueSetService(valueSetUrl: valueSetUrl, signatureUrl: valueSetSignatureUrl, trustAnchor: valueSetTrustAnchor, apiKey: valueSetApiKey, dateService: nil, storeEncrypted: encryptValueSet)
    }
    
    @objc func validate(_ call: CAPPluginCall) {
        let qrString = call.getString("qrString") ?? ""
        validationCore.validate(encodedData: qrString, { result in
            call.resolve(["result": result])
        })
    }
    
    @objc func updateTrustlist(_ call: CAPPluginCall) {
        validationCore.updateTrustlist { error in
            call.resolve(["error": error?.rawValue])
        }
    }
    
    @objc func updateBusinessRules(_ call: CAPPluginCall) {
        dccCachingService.businessRulesService.updateDataIfNecessary(force: false) { error in
            call.resolve(["error": error?.rawValue])
        }
    }
    
    @objc func updateValueSet(_ call: CAPPluginCall) {
        dccCachingService.valueSetService.updateDataIfNecessary(force: false) { error in
            call.resolve(["error": error?.rawValue])
        }
    }
    
    
    @objc func decodeBusinessRules(_ call: CAPPluginCall) {
        let businessRulesData = call.getArray("businessRulesData", UInt8.self)
        let signatureData = call.getArray("signatureData", UInt8.self)
        let trustAnchor = call.getString("trustAnchor")

        guard let businessRulesData = businessRulesData,
              let signatureData = signatureData,
              let trustAnchor = trustAnchor else {
            call.reject("Supplied parameter is null")
            return
        }
        
        do {
            let (signatureInfo, businessRulesContainer) = try validationCore.decode(businessRules: Data(businessRulesData), signature: Data(signatureData), trustAnchor: trustAnchor)
            call.resolve(["signatureInfo": signatureInfo, "businessRulesContainer": businessRulesContainer])
        } catch (let error) {
            call.reject(error.localizedDescription)
        }
    }
    
    @objc func decodeValueSet(_ call: CAPPluginCall) {
            let valueSetData = call.getArray("valueSetData", UInt8.self)
            let signatureData = call.getArray("signatureData", UInt8.self)
            let trustAnchor = call.getString("trustAnchor")

            guard let valueSetData = valueSetData,
                  let signatureData = signatureData,
                  let trustAnchor = trustAnchor else {
                call.reject("Supplied parameter is null")
                return
            }
            
            do {
                let (signatureInfo, valueSetContainer) = try validationCore.decode(valueSet: Data(valueSetData), signature: Data(signatureData), trustAnchor: trustAnchor)
                call.resolve(["signatureInfo": signatureInfo, "valueSetContainer": valueSetContainer])
            } catch (let error) {
                call.reject(error.localizedDescription)
            }
        }
}

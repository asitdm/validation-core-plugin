//
//  ValidationCorePlugin.swift
//  App
//
//  Created by Dominik Mocher on 30.06.21.
//

import Foundation
import ValidationCore
import Capacitor

@objc(ValidationCorePlugin)
public class ValidationCorePlugin: CAPPlugin {
    private var validationCore : ValidationCore? = ValidationCore()
    
    @objc func setup(_ call: CAPPluginCall) {
        let trustlistUrl = call.getString("trustlistUrl")
        let signatureUrl = call.getString("signatureUrl")
        let trustAnchor = call.getString("trustAnchor")
        validationCore = ValidationCore(trustlistService: nil, dateService: nil, trustlistUrl: trustlistUrl, signatureUrl: signatureUrl, trustAnchor: trustAnchor)
    }
    
    @objc func validate(_ call: CAPPluginCall) {
        let qrString = call.getString("qrString") ?? ""
        validationCore?.validate(encodedData: qrString, { result in
            call.resolve(["result": result])
        })
    }
    
    @objc func updateTrustlist(_ call: CAPPluginCall) {
        validationCore?.updateTrustlist { error in
            call.resolve(["error": error?.rawValue])
        }
    }
}

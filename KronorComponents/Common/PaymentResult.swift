//
//  PaymentResult.swift
//  Kronor
//
//  Created by Niclas Heltoft on 09/03/2026.
//

/// A payment result containing the id of the payment when successful.
public typealias PaymentResult = Result<String, PaymentError>

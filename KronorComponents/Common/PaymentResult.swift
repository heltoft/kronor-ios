//
//  PaymentResult.swift
//  Kronor
//
//  Created by Niclas Heltoft on 09/03/2026.
//

/// The result of a payment flow.
///
/// On success, contains the payment ID as a `String`.
///
/// On failure, contains a ``PaymentError`` describing what went wrong.
public typealias PaymentResult = Result<String, PaymentError>

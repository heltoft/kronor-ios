//
//  PaymentError.swift
//
//
//  Created by lorenzo on 2023-09-29.
//

/// Represents errors that can occur during a payment flow.
public enum PaymentError: Error {
    /// The payment was cancelled by the user.
    case cancelled
    /// The payment was declined by the payment provider.
    case declined
}

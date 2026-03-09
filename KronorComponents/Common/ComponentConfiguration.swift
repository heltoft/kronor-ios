//
//  ComponentConfiguration.swift
//  Kronor
//
//  Created by Niclas Heltoft on 09/03/2026.
//

import Foundation
import Kronor

/// Shared configuration for all payment components.
public struct ComponentConfiguration {
    /// The Kronor environment to use.
    public let env: Kronor.Environment
    /// The session token obtained from the backend via the `newPaymentSession` query.
    public let sessionToken: String
    /// The URL the payment flow will redirect back to upon completion.
    public let returnURL: URL
    /// Optional device information for device-specific payment flows.
    public let device: Kronor.Device?
    /// Whether or not websockets is used for payment status updates.
    public let isWebsocketsEnabled: Bool

    /// Creates a new component configuration.
    /// - Parameters:
    ///   - env: The Kronor environment to use.
    ///   - sessionToken: The session token obtained from the backend.
    ///   - returnURL: The URL to redirect back to after the payment flow.
    ///   - device: Optional device information. Defaults to `nil`.
    ///   - isWebsocketsEnabled: Whether or not websockets is used for payment status updates. Defaults to `true`.
    public init(
        env: Kronor.Environment,
        sessionToken: String,
        returnURL: URL,
        device: Kronor.Device? = nil,
        isWebsocketsEnabled: Bool = true
    ) {
        self.env = env
        self.sessionToken = sessionToken
        self.returnURL = returnURL
        self.device = device
        self.isWebsocketsEnabled = isWebsocketsEnabled
    }
}

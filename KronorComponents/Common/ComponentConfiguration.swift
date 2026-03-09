//
//  ComponentConfiguration.swift
//  Kronor
//
//  Created by Niclas Heltoft on 09/03/2026.
//

import Foundation
import Kronor

public struct ComponentConfiguration {
    public let env: Kronor.Environment
    public let sessionToken: String
    public let returnURL: URL
    public let device: Kronor.Device?

    public init(
        env: Kronor.Environment,
        sessionToken: String,
        returnURL: URL,
        device: Kronor.Device? = nil
    ) {
        self.env = env
        self.sessionToken = sessionToken
        self.returnURL = returnURL
        self.device = device
    }
}

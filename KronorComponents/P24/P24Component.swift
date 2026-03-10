//
//  P24Component.swift
//
//
//  Created by lorenzo on 2024-07-08.
//

import SwiftUI
import Kronor

/// A payment component that handles Przelewy24 (P24) payments.
public struct P24Component: View {
    let viewModel: EmbeddedPaymentViewModel

    /// Creates a new P24 payment component.
    /// - Parameters:
    ///   - configuration: The shared component configuration.
    ///   - paymentResultHandler: A closure called with the payment result.
    public init(
        configuration: ComponentConfiguration,
        paymentResultHandler: @escaping PaymentResultHandler
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorEmbeddedPaymentNetworking(configuration: configuration)
        let viewModel = EmbeddedPaymentViewModel(
            configuration: configuration,
            stateMachine: machine,
            networking: networking,
            paymentMethod: .p24,
            paymentResultHandler: paymentResultHandler
        )
        
        self.viewModel = viewModel
        
        Task {
            await viewModel.initialize()
        }
    }

    public var body: some View {
        WrapperView(header: FallbackHeaderView()) {
            EmbeddedPaymentView(
                viewModel: self.viewModel,
                waitingView: FallbackWaitingView()
            )
        }
    }
}

struct P24Component_Previews: PreviewProvider {
    static var previews: some View {
        P24Component(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

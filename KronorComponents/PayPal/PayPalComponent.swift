//
//  PayPalComponent.swift
//  
//
//  Created by lorenzo on 2023-01-26.
//

import SwiftUI
import Kronor

/// A payment component that handles PayPal payments.
public struct PayPalComponent: View {
    let viewModel: EmbeddedPaymentViewModel

    /// Creates a new PayPal payment component.
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
            paymentMethod: .payPal,
            paymentResultHandler: paymentResultHandler
        )

        self.viewModel = viewModel

        Task {
            await viewModel.transition(.initialize)
        }
    }

    public var body: some View {
        WrapperView(header: PayPalHeaderView()) {
            EmbeddedPaymentView(
                viewModel: self.viewModel,
                waitingView: PayPalWaitingView()
            )
        }
    }
}

struct PayPalComponent_Previews: PreviewProvider {
    static var previews: some View {
        PayPalComponent(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

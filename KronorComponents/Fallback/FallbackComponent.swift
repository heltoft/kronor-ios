//
//  FallbackComponent.swift
//
//
//  Created by lorenzo on 2023-01-17.
//

import SwiftUI
import Kronor

/// A generic payment component that handles payment methods without a dedicated component.
public struct FallbackComponent: View {
    let viewModel: EmbeddedPaymentViewModel

    /// Creates a new fallback payment component.
    /// - Parameters:
    ///   - configuration: The shared component configuration.
    ///   - paymentMethodName: The name of the payment method to use.
    ///   - paymentResultHandler: A closure called with the payment result.
    public init(
        configuration: ComponentConfiguration,
        paymentMethodName: String,
        paymentResultHandler: @escaping PaymentResultHandler
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorEmbeddedPaymentNetworking(configuration: configuration)
        let viewModel = EmbeddedPaymentViewModel(
            configuration: configuration,
            stateMachine: machine,
            networking: networking,
            paymentMethod: .fallback(name: paymentMethodName),
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

struct FallbackComponent_Previews: PreviewProvider {
    static var previews: some View {
        FallbackComponent(
            configuration: Preview.configuration,
            paymentMethodName: "swish",
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

//
//  MobilePayComponent.swift
//  
//
//  Created by lorenzo on 2023-01-17.
//

import SwiftUI
import Kronor

/// A payment component that handles MobilePay payments.
public struct MobilePayComponent: View {
    let viewModel: EmbeddedPaymentViewModel

    /// Creates a new MobilePay payment component.
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
            paymentMethod: .mobilePay,
            paymentResultHandler: paymentResultHandler
        )

        self.viewModel = viewModel

        Task {
            await viewModel.transition(.initialize)
        }
    }

    public var body: some View {
        WrapperView(header: MobilePayHeaderView()) {
            EmbeddedPaymentView(
                viewModel: self.viewModel,
                waitingView: MobilePayWaitingView()
            )
        }
    }
}

struct MobilePayComponent_Previews: PreviewProvider {
    static var previews: some View {
        MobilePayComponent(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

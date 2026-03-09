//
//  BankTransferComponent.swift
//
//
//  Created by lorenzo on 2024-04-16.
//

import SwiftUI
import Kronor

/// A payment component that handles bank transfer payments.
public struct BankTransferComponent: View {
    let viewModel: EmbeddedPaymentViewModel

    /// Creates a new bank transfer payment component.
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
            paymentMethod: .bankTransfer,
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

struct BankTransferComponent_Previews: PreviewProvider {
    static var previews: some View {
        BankTransferComponent(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

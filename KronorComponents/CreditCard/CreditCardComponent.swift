//
//  CreditCardComponent.swift
//  
//
//  Created by lorenzo on 2023-01-23.
//

import SwiftUI
import Kronor

public struct CreditCardComponent: View {
    let viewModel: EmbeddedPaymentViewModel
    
    public init(
        configuration: ComponentConfiguration,
        onPaymentFailure: @escaping (_ reason: FailureReason) -> (),
        onPaymentSuccess: @escaping (_ paymentId: String) -> ()
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorEmbeddedPaymentNetworking(configuration: configuration)
        let viewModel = EmbeddedPaymentViewModel(
            configuration: configuration,
            stateMachine: machine,
            networking: networking,
            paymentMethod: .creditCard,
            onPaymentFailure: onPaymentFailure,
            onPaymentSuccess: onPaymentSuccess
        )

        self.viewModel = viewModel

        Task {
            await viewModel.transition(.initialize)
        }
    }

    public var body: some View {
        WrapperView(header: CreditCardHeaderView(viewModel: self.viewModel)) {
            EmbeddedPaymentView(viewModel: self.viewModel, waitingView: CreditCardWaitingView())
        }
    }
}

struct CreditCardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CreditCardComponent(
            configuration: Preview.configuration,
            onPaymentFailure: { reason in
                print("failed: \(reason)")
            }
        ) { paymentId in
            print("done: \(paymentId)")
        }
    }
}

//
//  FallbackComponent.swift
//
//
//  Created by lorenzo on 2023-01-17.
//

import SwiftUI
import Kronor

public struct FallbackComponent: View {
    let viewModel: EmbeddedPaymentViewModel
    
    public init(
        configuration: ComponentConfiguration,
        paymentMethodName: String,
        onPaymentFailure: @escaping (_ reason: FailureReason) -> (),
        onPaymentSuccess: @escaping (_ paymentId: String) -> ()
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorEmbeddedPaymentNetworking(configuration: configuration)
        let viewModel = EmbeddedPaymentViewModel(
            configuration: configuration,
            stateMachine: machine,
            networking: networking,
            paymentMethod: .fallback(name: paymentMethodName),
            onPaymentFailure: onPaymentFailure,
            onPaymentSuccess: onPaymentSuccess
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
            onPaymentFailure: { reason in
                print("failed: \(reason)")
            }
        ) { paymentId in
            print("done: \(paymentId)")
        }
    }
}

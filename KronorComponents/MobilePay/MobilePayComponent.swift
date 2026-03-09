//
//  MobilePayComponent.swift
//  
//
//  Created by lorenzo on 2023-01-17.
//

import SwiftUI
import Kronor

public struct MobilePayComponent: View {
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
            paymentMethod: .mobilePay,
            onPaymentFailure: onPaymentFailure,
            onPaymentSuccess: onPaymentSuccess
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
            onPaymentFailure: { reason in
                print("failed: \(reason)")
            }
        ) { paymentId in
            print("done: \(paymentId)")
        }
    }
}

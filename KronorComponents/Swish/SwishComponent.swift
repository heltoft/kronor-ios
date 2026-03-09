//
//  SwishComponent.swift
//  kronor-ios
//
//  Created by lorenzo on 2023-01-10.
//

import SwiftUI
import Kronor

public struct SwishComponent: View {
    let viewModel: SwishPaymentViewModel
    
    public init(
        configuration: ComponentConfiguration,
        onPaymentFailure: @escaping (_ reason: FailureReason) -> (),
        onPaymentSuccess: @escaping (_ paymentId: String) -> ()
    ) {
        let machine = SwishStatechart.makeStateMachine()
        let networking = KronorSwishPaymentNetworking(configuration: configuration)
        self.viewModel = SwishPaymentViewModel(
            stateMachine: machine,
            networking: networking,
            returnURL: configuration.returnURL,
            onPaymentFailure: onPaymentFailure,
            onPaymentSuccess: onPaymentSuccess
        )

    }

    public var body: some View {
        SwishPaymentView(viewModel: self.viewModel)
    }
}

struct SwishComponent_Previews: PreviewProvider {
    static var previews: some View {
        SwishComponent(
            configuration: Preview.configuration,
            onPaymentFailure: { reason in
                print("failed: \(reason)")
            }
        ) { paymentId in
            print("done: \(paymentId)")
        }
    }
}

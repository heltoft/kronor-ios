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
        paymentResultHandler: @escaping PaymentResultHandler
    ) {
        let machine = SwishStatechart.makeStateMachine()
        let networking = KronorSwishPaymentNetworking(configuration: configuration)
        self.viewModel = SwishPaymentViewModel(
            stateMachine: machine,
            networking: networking,
            returnURL: configuration.returnURL,
            paymentResultHandler: paymentResultHandler
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
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

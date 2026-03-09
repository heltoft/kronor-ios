//
//  VippsComponent.swift
//  
//
//  Created by lorenzo on 2023-01-25.
//

import SwiftUI
import Kronor

public struct VippsComponent: View {
    let viewModel: EmbeddedPaymentViewModel
    
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
            paymentMethod: .vipps,
            paymentResultHandler: paymentResultHandler
        )

        self.viewModel = viewModel

        Task {
            await viewModel.transition(.initialize)
        }
    }

    public var body: some View {
        WrapperView(header: VippsHeaderView()) {
            EmbeddedPaymentView(
                viewModel: self.viewModel,
                waitingView: VippsWaitingView()
            )
        }
    }
}

struct VippsComponent_Previews: PreviewProvider {
    static var previews: some View {
        VippsComponent(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}


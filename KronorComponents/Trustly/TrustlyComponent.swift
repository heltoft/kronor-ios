import SwiftUI
import Kronor

public struct TrustlyComponent: View {
    let viewModel: TrustlyPaymentViewModel
    
    public init(
        configuration: ComponentConfiguration,
        paymentResultHandler: @escaping PaymentResultHandler
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorTrustlyPaymentNetworking(configuration: configuration)
        let viewModel = TrustlyPaymentViewModel(
            stateMachine: machine,
            networking: networking,
            returnURL: configuration.returnURL,
            paymentResultHandler: paymentResultHandler
        )
        
        self.viewModel = viewModel
        
        Task {
            await viewModel.transition(.initialize)
        }
    }

    public var body: some View {
        TrustlyPaymentView(viewModel: self.viewModel)
    }
}

struct TrustlyComponent_Previews: PreviewProvider {
    static var previews: some View {
        TrustlyComponent(
            configuration: Preview.configuration,
            paymentResultHandler: Preview.paymentResultHandler
        )
    }
}

import SwiftUI
import Kronor

/// A payment component that handles Trustly payments.
public struct TrustlyComponent: View {
    let viewModel: TrustlyPaymentViewModel

    /// Creates a new Trustly payment component.
    /// - Parameters:
    ///   - configuration: The shared component configuration.
    ///   - paymentResultHandler: A closure called with the payment result.
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

import SwiftUI
import Kronor

public struct TrustlyComponent: View {
    let viewModel: TrustlyPaymentViewModel
    
    public init(env: Kronor.Environment,
                sessionToken: String,
                returnURL: URL,
                device: Kronor.Device? = nil,
                onPaymentFailure: @escaping (_ reason: FailureReason) -> (),
                onPaymentSuccess: @escaping (_ paymentId: String) -> ()
    ) {
        let machine = EmbeddedPaymentStatechart.makeStateMachine()
        let networking = KronorTrustlyPaymentNetworking(
            env: env,
            token: sessionToken,
            device: device
        )
        let viewModel = TrustlyPaymentViewModel(
            stateMachine: machine,
            networking: networking,
            returnURL: returnURL,
            onPaymentFailure: onPaymentFailure,
            onPaymentSuccess: onPaymentSuccess
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
            env: Preview.env,
            sessionToken: Preview.token,
            returnURL: Preview.returnURL,
            onPaymentFailure: { reason in
                print("failed: \(reason)")
            }
        ) { paymentId in
            print("done: \(paymentId)")
        }
    }
}

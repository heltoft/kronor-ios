import SwiftUI
import TrustlyIosSdk
import os

struct TrustlyPaymentView: View {
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: TrustlyPaymentView.self)
    )
    
    @State private var isShowingTrustly = false

    @ObservedObject var viewModel: TrustlyPaymentViewModel
    
    var body: some View {
        TrustlyWrapperView(content: generateContentView)
    }
    
    let waitingView = HStack {
        Spacer()
        Image(systemName: "hourglass.circle")
        Text(
            "creating_trustly",
            bundle: .module,
            comment:  "A waiting message that indicates that the app is communicating with the server"
        )
        .font(.subheadline)
        Spacer()
    }
    
    func dismissPayment() -> Void {
        Task {
            await self.viewModel.transition(.cancel)
            isShowingTrustly = false
        }
    }

    @ViewBuilder func generateContentView() -> some View {
        switch viewModel.state {
        case  .initializing, .creatingPaymentRequest, .waitingForPaymentRequest:
            waitingView
        case .paymentRequestInitialized, .waitingForPayment:
            waitingView
                .onAppear {
                    isShowingTrustly = true
                }
                .sheet(isPresented: $isShowingTrustly, onDismiss: self.dismissPayment) {
                    if let url = self.viewModel.trustlyCheckoutURL {

                        let _ = Self.logger.info("going to render trustly")
                        GeometryReader { proxy in
                            TrustlyWebView(
                                checkoutURL: url.absoluteString,
                                onSuccess: {
                                    Self.logger.info("Truslty success")
                                    isShowingTrustly = false
                                },
                                onError: {
                                    Self.logger.error("Trustly error")
                                    isShowingTrustly = false
                                    Task {
                                        await self.viewModel.transition(.paymentRejected)
                                    }
                                },
                                onAbort: {
                                    Self.logger.warning("Trustly abort")
                                    isShowingTrustly = false
                                    Task {
                                        await self.viewModel.transition(.cancel)
                                    }
                                },
                                geometry: proxy
                            )
                        }
                    }
                }
        case .paymentRejected:
            PaymentRejectedView(viewModel: self.viewModel)
        case .paymentCompleted:
            HStack {
                Spacer()
                Image(systemName: "checkmark.circle")
                    .foregroundColor(Color.green)

                Text(
                    "payment_completed",
                    bundle: .module,
                    comment:  "A success message indicating that the payment was completed and the payment session will end"
                )
                .font(.headline)
                .foregroundColor(Color.green)

                Spacer()
            }
        case .errored(_):
            HStack {
                Spacer()
                Image(systemName: "xmark.circle")
                    .foregroundColor(Color.red)

                Text(
                    "Could not complete the payment due to an error. Please try again after a short time",
                    bundle: .module,
                    comment:  "An error message indicating there was an unexpected error with the payment"
                )
                .font(.headline)
                .foregroundColor(Color.red)

                Spacer()
            }
        }
    }
}

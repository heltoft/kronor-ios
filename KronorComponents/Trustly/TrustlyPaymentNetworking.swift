import Foundation
import Kronor
import KronorApi

protocol TrustlyPaymentNetworking: PaymentNetworking {
    func createPaymentRequest(
        returnURL: URL
    ) async -> Result<String, KronorApi.KronorError>
}

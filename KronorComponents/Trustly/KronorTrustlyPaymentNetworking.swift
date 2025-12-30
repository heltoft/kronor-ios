import Foundation
import Kronor
import KronorApi

final class KronorTrustlyPaymentNetworking: KronorPaymentNetworking, TrustlyPaymentNetworking {
    func createPaymentRequest(
        returnURL: URL
    ) async -> Result<String, KronorApi.KronorError> {
        let input = KronorApi.BankTransferPaymentInput(
            flow: "mcom",
            idempotencyKey: UUID().uuidString,
            returnUrl: returnURL.absoluteString
        )

        return await KronorApi.createBankPaymentRequest(
            client: client,
            input: input,
            deviceInfo: deviceInfo
        )
    }
}

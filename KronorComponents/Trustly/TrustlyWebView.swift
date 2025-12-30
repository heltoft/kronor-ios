import SwiftUI
import WebKit
import TrustlyIosSdk
import os

struct TrustlyWebView: UIViewRepresentable {
    
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: TrustlyWebView.self)
    )
    
    let checkoutURL: String
    
    // closures to handle events back in your main SwiftUI view
    var onSuccess: (() -> Void)?
    var onError: (() -> Void)?
    var onAbort: (() -> Void)?

    let geometry: GeometryProxy

    func makeUIView(context: Context) -> TrustlyWKWebView {
        // Initialize the view.
        let size = geometry.size
        guard let trustlyWebView = TrustlyWKWebView(checkoutUrl: checkoutURL, frame: CGRect(x: 0, y: 0, width: size.width, height: size.height)) else {
            fatalError("Could not initialize TrustlyWKWebView. checkoutURL='\(checkoutURL)'. This may indicate an invalid URL format or a Trustly iOS SDK initialization/configuration issue.")
        }
        
        // Connect the library's event handlers to our SwiftUI closures
        trustlyWebView.onSuccess = {
            self.onSuccess?()
        }
        
        trustlyWebView.onError = {
            self.onError?()
        }
        
        trustlyWebView.onAbort = {
            self.onAbort?()
        }

        return trustlyWebView
    }
    
    func updateUIView(_ uiView: TrustlyIosSdk.TrustlyWKWebView, context: Context) {
        Self.logger.info("updating view \(String(describing: uiView.frame))")
    }
}

import SwiftUI
import WebKit
import TrustlyIosSdk
import os

struct TrustlyWebView: UIViewRepresentable {
    typealias UIViewType = UIView
    
    private static let logger = Logger(
            subsystem: Bundle.main.bundleIdentifier!,
            category: String(describing: TrustlyWebView.self)
    )
    
    private let checkoutURL: String
    
    // closures to handle events back in your main SwiftUI view
    private let onSuccess: (() -> Void)?
    private let onError: (() -> Void)?
    private let onAbort: (() -> Void)?

    private let geometry: Binding<GeometryProxy>
    
    private var preferredFrame: CGRect {
            CGRect(
                x: 0,
                y: 0,
                width: geometry.wrappedValue.size.width,
                height: geometry.wrappedValue.size.height
            )
    }
    
    init(
            checkoutURL: String,
            geometry: Binding<GeometryProxy>,
            onSuccess: (() -> Void)?,
            onError: (() -> Void)?,
            onAbort: (() -> Void)?
        ) {
            self.geometry = geometry
            self.checkoutURL = checkoutURL
            self.onSuccess = onSuccess
            self.onError = onError
            self.onAbort = onAbort
        }

    func makeUIView(context: Context) -> UIView {
        // Initialize the view.
        guard let trustlyWebView = TrustlyWKWebView(checkoutUrl: checkoutURL, frame: preferredFrame) else {
            Self.logger.error("Could not initialize TrustlyWKWebView. checkoutURL='\(checkoutURL)'. This may indicate an invalid URL format or a Trustly iOS SDK initialization/configuration issue.")
            return UIView()
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
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.subviews.compactMap { $0 as? WKWebView }.first?.frame = preferredFrame
    }
}

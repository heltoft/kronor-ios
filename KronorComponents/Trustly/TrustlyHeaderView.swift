import SwiftUI

struct TrustlyHeaderView: View {
    static let trustlyLogoPath = Bundle.module.path(forResource: "trustly-logo", ofType: "png")!
    static let trustlyLogo = UIImage(contentsOfFile: trustlyLogoPath)!

    static let trustlyLogoDarkPath = Bundle.module.path(forResource: "trustly-logo-dark", ofType: "png")!
    static let trustlyLogoDark = UIImage(contentsOfFile: trustlyLogoDarkPath)!
    @Environment(\.colorScheme) var currentMode

    var body: some View {
        VStack {
            Image(uiImage: currentMode == .dark ? Self.trustlyLogoDark : Self.trustlyLogo)
                .resizable()
                .aspectRatio(contentMode: .fit)
        }.frame(width: 150,
                height: 250,
                alignment: .leading)
    }
}

struct TrustlyHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        TrustlyHeaderView()
            .previewDisplayName("Logo")

        TrustlyHeaderView()
            .preferredColorScheme(.dark)
            .previewDisplayName("Logo Dark")
    }
}

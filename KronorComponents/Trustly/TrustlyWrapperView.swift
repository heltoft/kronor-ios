import SwiftUI

struct TrustlyWrapperView<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        VStack {
            Spacer()
            TrustlyHeaderView()
            Spacer()
            content
            Spacer()
        }
    }
}

struct TrustlyWrapperView_Previews: PreviewProvider {
    static var previews: some View {
        TrustlyWrapperView {
            Text("Dummy Contents")
        }
    }
}

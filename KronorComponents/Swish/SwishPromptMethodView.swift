//
//  SwishPromptMethodView.swift
//  kronor-ios
//
//  Created by lorenzo on 2023-01-04.
//

import SwiftUI

struct SwishPromptMethodView: View {
    var viewModel : SwishPaymentViewModel
    
    var body: some View {
        VStack {
            Spacer()

            Button(action: {
                Task {
                    await viewModel.transition(.useSwishApp)
                }
            }) {
                Text(
                    "Open Swish App",
                    bundle: .module,
                    comment: "A button label that indicates the customer wants to pay with the Swish app in the same device"
                )
            }
                .disabled(!viewModel.swishAppInstalled)

            Spacer()
            
            
            Text(
                "or pay using another phone",
                bundle: .module,
                comment: ""
            )
                .fontWeight(.thin)
                .foregroundColor(Color.gray)
                .padding(.vertical)
            
            Button(action: {
                Task {
                    await viewModel.transition(.useQR)
                }
            }) {
                Text(
                    "Scan QR Code",
                    bundle: .module,
                    comment: "A button label that indicates the customer wants to pay by scanning a QR code in another device"
                )
            }
                .padding(.top)
            
            Button(action: {
                Task {
                    await viewModel.transition(.usePhoneNumber)
                }
            }) {
                Text(
                    "Enter phone number",
                    bundle: .module,
                    comment: "A button label that indicates the customer wants to pay getting a notification in another device"
                )
                
            }
                .padding(.vertical)

            Text(String())
        }
    }
}

struct SwishPromptMethodView_Previews: PreviewProvider {
    static let viewModel = Preview.makeSwishPaymentViewModel()

    static var previews: some View {
        SwishWrapperView {
            SwishPromptMethodView(viewModel: viewModel)
        }
    }
}

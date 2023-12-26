//
//  ErrorView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/7/23.
//


import SwiftUI

struct ErrorView: View {
    let error: Error
    let retryAction: () -> Void
    
    var body: some View {
        VStack {
            Text("An Error Occured")
                .font(.title)
            Text(error.localizedDescription)
                .font(.callout)
                .multilineTextAlignment(.center)
                .padding(.bottom, 40).padding()
            retryBtnView
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(ColorPallet.Celeste)
                .shadow(radius: 8)
        )
    }
    
    @ViewBuilder var retryBtnView: some View{
        Button(action: {
            retryAction()
        }, label: {
            Text("Retry")
                .font(
                    Font.custom("SF Pro Text", size: 16)
                        .weight(.semibold)
                )
                .multilineTextAlignment(.center)
                .foregroundColor(ColorPallet.TextYellow)
        })
        .padding(.horizontal, 50)
        .padding(.vertical, 5)
        .frame(height: 54, alignment: .center)
        .background(ColorPallet.DarkGreen)
        .cornerRadius(50)
    }
}

#if DEBUG
struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView(error: NSError(domain: "", code: 0, userInfo: [
            NSLocalizedDescriptionKey: "Something went wrong"]),
                  retryAction: { })
    }
}
#endif


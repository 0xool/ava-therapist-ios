//
//  ErrorView.swift
//  AITherapist
//
//  Created by Cyrus Refahi on 9/7/23.
//

import SwiftUI

struct ErrorView: View {
    let error: Error
    let message: String
    let retryAction: () -> Void
    
    private var formHeight: CGFloat {
        CGFloat(UIViewController().view.bounds.height * 0.7)
    }
    
    init(error: Error, retryAction: @escaping () -> Void) {
        self.error = error
        self.retryAction = retryAction
        if let serverError = error as? ServerError {
            self.message = serverError.message ?? "Network error"
        }else{
            message = error.localizedDescription
        }
        
    }
    
    var body: some View {
        mainView
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.clear)
    }
    
    @ViewBuilder var mainView: some View {
        ZStack {
            VStack(spacing: 24){
                Text("Oops!\n")
                    .bold()
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .foregroundColor(ColorPallet.DarkBlue)
                    .frame(alignment: .top)
                    .padding(.top, 16)
                VStack{
//                    Text("Looks like something went wrong!")
//                        .fixedSize(horizontal: false, vertical: true)
//                        .font(Font.custom("SF Pro Text", size: 17))
//                        .multilineTextAlignment(.center)
//                        .lineLimit(3)
//                        .foregroundColor(ColorPallet.DarkBlue)
//                        .frame(alignment: .top)
                    
                    Text(message)
                        .fixedSize(horizontal: false, vertical: true)
                        .font(Font.custom("SF Pro Text", size: 17))
                        .multilineTextAlignment(.center)
                        .lineLimit(3)
                        .foregroundColor(ColorPallet.DarkBlue)
                        .frame(alignment: .top)
                }.onAppear {
                    print(error)
                }
                                
                errorIcon
                
                Spacer()
                
                Button(action: {
                    retryAction()
                }, label: {
                    Text("Retry")
                        .foregroundStyle(ColorPallet.Celeste)
                        .bold()
                })
                .padding(.horizontal, 30)
                .padding(.vertical, 0)
                .frame(maxWidth: .infinity, minHeight: 40, maxHeight: 40, alignment: .center)
                .background(ColorPallet.DeepAquaBlue)
                .cornerRadius(50)
                
            Spacer()
                
            }
            .padding()
            .frame(maxHeight: .infinity)
            
            
        }
        .frame(height: formHeight)
        .frame(maxWidth: .infinity)
        .background(.white)
        .cornerRadius(25)
        .shadow(color: .black.opacity(0.25), radius: 3.5, x: 4, y: 6)
        .padding()
    }
    
    @ViewBuilder var errorIcon: some View{
        ZStack{
            Image("ErrorEar")
            Image("Mobile")
            Image("ErrorCross")
        }
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


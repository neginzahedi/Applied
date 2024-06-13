//
//  IntroView.swift
//  Applied
//

import SwiftUI

struct IntroView: View {
    
    // MARK: - Properties
    
    @Binding var showIntro: Bool
    
    // MARK: - Body
    
    var body: some View {
        VStack{
            Spacer()
            Image("intro")
                .resizable()
                .scaledToFit()
                .padding(50)
            Spacer()
            VStack{
                Text("Welcome to Applied")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 15)
                
                Text("Applied assists you in staying organized and conveniently tracking your job applications.")
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
            }
            .padding()
            startButton
            Spacer()
        }
    }
    // MARK: - Computed Properties
    
    private var startButton: some View{
        Button(action: {
            UserDefaults.standard.set(false, forKey: Constants.introKey)
            withAnimation {
                self.showIntro = false
            }
        }, label: {
            Text("Get Started")
                .frame(width: 200, height: 50, alignment: .center)
                .background(Color(.customYellow))
                .clipShape(Capsule())
                .bold()
        })
    }
}

// MARK: - Preview IntroView

#if DEBUG
#Preview {
    IntroView(showIntro: .constant(true))
}
#endif

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
                    .fontDesign(.rounded)
                    .padding(.bottom, 15)
                
                Text("Applied assists you in staying organized and conveniently tracking your job applications.")
                    .multilineTextAlignment(.center)
                    .fontDesign(.rounded)
                    .foregroundStyle(.secondary)
            }
            .padding()
            
            Button(action: {
                // Update UserDefaults flag
                UserDefaults.standard.set(false, forKey: "hasShownIntro")
                // Update showIntro to false
                self.showIntro = false
            }, label: {
                Text("Get Started")
                    .frame(width: 200, height: 50, alignment: .center)
                    .background(Color(red: 255/255, green: 206/255, blue: 0/255))
                    .clipShape(Capsule())
                    .foregroundColor(.black)
                    .font(.headline)
                    .fontDesign(.rounded)
            })
            
            Spacer()
        }
    }
}

// MARK: - Preview IntroView

#if DEBUG
#Preview {
    IntroView(showIntro: .constant(true))
}
#endif

//
//  ContentView.swift
//  Applied
//

import SwiftUI

// MARK: - Content View

struct ContentView: View {
    
    // MARK: - Properties
    
    @State private var showIntro = true
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                MainView()
            }
        }
        .fontDesign(.rounded)
        .onAppear {
            // Check if intro has been shown before
            if UserDefaults.standard.bool(forKey: "hasShownIntro") == false {
                print(UserDefaults.standard.bool(forKey: "hasShownIntro"))
                self.showIntro = false
            }
        }
    }
}

// MARK: - Content View Preview

#if DEBUG
#Preview {
    ContentView()
}
#endif

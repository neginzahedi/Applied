//
//  MainView.swift
//  Applied
//

import SwiftUI

struct MainView: View {
    
    // MARK: - Properties
    
    @State var showIntro: Bool = true
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack{
            if showIntro {
                IntroView(showIntro: $showIntro)
            } else {
                DashboardView()
            }
        }
        .fontDesign(.rounded)
        .tint(.primary)
        
        .onAppear(){
            if UserDefaults.standard.object(forKey: "hasShownIntro") != nil {
                // Key exists
                showIntro = false
            } else {
                // Key does not exist
                showIntro = true
            }
        }
    }
}


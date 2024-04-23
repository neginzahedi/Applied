//
//  AppliedApp.swift
//  Applied
//

import SwiftUI

@main
struct AppliedApp: App {
    
    let dataController = DataController.shared
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext,dataController.container.viewContext)
        }
    }
}

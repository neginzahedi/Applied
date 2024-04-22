//
//  AppliedApp.swift
//  Applied
//

import SwiftUI

@main
struct AppliedApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext,dataController.container.viewContext)
        }
    }
}

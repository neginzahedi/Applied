//
//  AppliedApp.swift
//  Applied
//
//  Created by Negin Zahedi on 2024-03-27.
//

import SwiftUI

@main
struct AppliedApp: App {
    
    @StateObject private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext,dataController.container.viewContext)
        }
    }
}

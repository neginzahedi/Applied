//
//  AppliedApp.swift
//  Applied
//

import SwiftUI

@main
struct AppliedApp: App {
    
    let dataController = DataController.shared
    
    init() {
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor.label
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext,dataController.container.viewContext)
        }
    }
}

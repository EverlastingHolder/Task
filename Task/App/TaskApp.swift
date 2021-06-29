//
//  TaskApp.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI

@main
struct TaskApp: App {
    let persistenceController = PersistenceController.shared

    @StateObject private var viewModel: Self.ViewModel = .init()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)       
        }
    }
}

//
//  TaskApp.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI

@available(iOS 15.0, *)
@main
struct TaskApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

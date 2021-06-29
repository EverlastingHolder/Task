//
//  TaskAppViewModel.swift
//  Task
//
//  Created by Роман Мошковцев on 29.06.2021.
//

import Foundation
import Combine

extension TaskApp {
    class ViewModel: ObservableObject {
        @Published("countCurrentTask") var countCurrentTask: Int = 0
        @Published("countCompletedTask") var countCompletedTask: Int = 0
    }
}

//
//  AppViewModel.swift
//  Task
//
//  Created by Роман Мошковцев on 27.06.2021.
//

import Foundation

@available(iOS 15.0, *)
extension AddTaskView {
    class ViewModel: ObservableObject {
        @Published var isError: Bool = false
        @Published var errorTitle: String = ""
        @Published var errorMessage: String = ""
    }
}

//
//  ButtonsStyle.swift
//  Task
//
//  Created by Роман Мошковцев on 27.06.2021.
//

import Foundation

enum ButtonsStyle {
    case long, favorite
    
    var isTag: Bool {
        switch self {
            case .favorite: return true
            case .long: return true
        }
    }
}
extension ButtonsStyle: Equatable {
    static func ==(lhs: ButtonsStyle, rhs: ButtonsStyle) -> Bool {
        switch (lhs, rhs) {
            case (.long, .long): return true
            case (.favorite, .favorite): return true
            default: return false
        }
    }
}

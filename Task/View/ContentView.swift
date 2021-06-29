//
//  ContentView.swift
//  Task
//
//  Created by Роман Мошковцев on 25.06.2021.
//

import SwiftUI

struct ContentView: View {    
    @State private var navigation: [NavigationItem] = [
        NavigationItem(
            title: "Current",
            icon: "tray.and.arrow.down.fill",
            color: .green,
            navigation: AnyView(CurrentTasksView())
        ),
        NavigationItem(
            title: "Completed",
            icon: "clock.badge.checkmark",
            color: .blue,
            navigation: AnyView(CompletedTasksView())
        )
    ]
    
    var body: some View {
        NavigationView {
            List(navigation, id: \.title) { item in
                NavigationLink(destination: item.navigation) {
                    Label(
                        title: {
                        Text(item.title)
                    },
                        icon: { Image(systemName: item.icon).foregroundColor(item.color) }
                    )
                }
            }.navigationBarTitle(Text("Task"), displayMode: .inline)
        }
    }
    
    private struct NavigationItem<Navigation: View> {
        let title: String
        let icon: String
        let color: Color
        let navigation: Navigation
    }
}

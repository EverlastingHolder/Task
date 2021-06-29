//
//  CompleteTaskView.swift
//  Task
//
//  Created by Роман Мошковцев on 29.06.2021.
//
import SwiftUI
import CoreData

struct CompletedTasksView: View {
    @EnvironmentObject
    private var viewModel: TaskApp.ViewModel
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \SimpleTasks.date, ascending: false)],
        predicate: NSPredicate(format: "isComplete == %@", NSNumber(booleanLiteral: true)),
        animation: .default)
    private var items: FetchedResults<SimpleTasks>
    
    var body: some View {
        List {
            Section{
                HStack {
                    Text("Total tasks")
                    Spacer()
                    Text(viewModel.countCompletedTask.description)
                }
            }
            ForEach(items) { item in
                VStack(alignment: .leading) {
                    HStack {
                        Text(item.title ?? "")
                            .font(.headline)
                        HStack {
                            ForEach(item.tags ?? [], id: \.self) { tag in
                                Text(tag.title ?? "")
                                    .padding(.horizontal)
                                    .padding(.vertical, 4)
                                    .background(tag.color)
                                    .opacity(1)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    Text(item.task ?? "" )
                }
            }
        }.navigationBarTitle(Text("Completed tasks"), displayMode: .inline)
    }
}


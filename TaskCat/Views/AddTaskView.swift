//
//  AddTaskView.swift
//  TaskCat
//
//  Created by Tochishita Haruki on 2026/02/21.
//

import SwiftUI

struct AddTaskView: View {

    @ObservedObject var viewModel: TaskViewModel
    @Environment(\.dismiss) var dismiss

    @State private var taskTitle: String = ""

    var body: some View {
        VStack(spacing: 20) {

            Text("新しいタスク")
                .font(.title)

            TextField("タスクを入力", text: $taskTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            Button("追加") {
                if !taskTitle.isEmpty {
                    viewModel.addTask(title: taskTitle)
                    dismiss()
                }
            }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding()
    }
}

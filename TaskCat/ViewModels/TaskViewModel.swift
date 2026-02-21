//
//  TaskViewModel.swift
//  TaskCat
//
//  Created by Tochishita Haruki on 2026/02/21.
//

import Foundation
import SwiftUI
import Combine


enum CatState {
    case walking
    case running
    case jumping
    case eating
    case satisfied
}


class TaskViewModel: ObservableObject {
    
    @Published var tasks: [Task] = []
    @Published var newTaskTitle: String = ""
    @Published var catState: CatState = .walking
    
    init() {
        loadTasks()
    }
    
    func addTask(title: String) {
        guard !title.isEmpty else { return }

        let task = Task(title: title)
        tasks.append(task)
        saveTasks()
    }
    
    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
        saveTasks()
    }
    
    func deleteCompletedTasks() {
        tasks.removeAll { $0.isCompleted }
        saveTasks()
    }
    
    func toggleComplete(task: Task) {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else { return }
        tasks[index].isCompleted.toggle()
        saveTasks()
        startCatAnimation()
    }
    
    private func saveTasks() {
        StorageManager.save(tasks: tasks)
    }
    
    private func loadTasks() {
        tasks = StorageManager.load()
    }
    
    private func startCatAnimation() {

        catState = .running

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.catState = .jumping
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
            self.catState = .eating
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.catState = .satisfied
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.catState = .walking
        }
    }

}


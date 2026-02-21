//
//  ContentView.swift
//  TaskCat
//
//  Created by Tochishita Haruki on 2026/02/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject private var viewModel = TaskViewModel()
    @State private var newTaskTitle = ""       // 追加行のテキスト
    @FocusState private var isInputActive: Bool // フォーカス管理
    @State private var isAddingTask = false
    
    var body: some View {
        ZStack {

            LinearGradient(
                colors: [
                    Color(red: 30/255, green: 30/255, blue: 35/255), // 上側
                    Color(red: 45/255, green: 45/255, blue: 50/255)  // 下側
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 16) {
                
                // 猫エリア
                // GeometryReader 内
                    GeometryReader { geo in
                        CatView(state: viewModel.catState, height: geo.size.height / 4)
                            .padding(.top, 20)
                            .frame(maxWidth: .infinity)
                    }
                // タスクリスト
                List {
                    // 既存タスク
                    ForEach(viewModel.tasks) { task in
                        HStack {
                            Button {
                                viewModel.toggleComplete(task: task) // タスク完了
                            } label: {
                                Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                    .foregroundColor(task.isCompleted ? .white : .gray.opacity(0.5))
                                    .font(.title3)
                            }

                            Text(task.title)
                                .font(.system(size: 16, weight: .medium))
                                .strikethrough(task.isCompleted)
                                .foregroundColor(task.isCompleted ? .gray.opacity(0.5) : .white)

                            Spacer()
                        }
                        .padding(.vertical, 3)
                        .listRowBackground(Color.clear)
                        .contentShape(Rectangle()) // 行全体をタップ可能に
                        .onTapGesture {
                            viewModel.toggleComplete(task: task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)

                    // 新規タスク編集中
                    if isAddingTask {
                        HStack {
                            Button {
                                if newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                    // 空白ならキャンセル
                                    isAddingTask = false
                                    newTaskTitle = ""
                                    isInputActive = false
                                } else {
                                    viewModel.addTask(title: newTaskTitle)
                                    newTaskTitle = ""
                                    isAddingTask = false
                                    isInputActive = false
                                }
                            } label: {
                                Image(systemName: "circle")
                                    .font(.title3)
                                    .foregroundColor(.gray.opacity(0.5))
                            }

                            TextField("新しいタスク", text: $newTaskTitle, axis: .vertical)
                                .focused($isInputActive)
                                .foregroundColor(.white)
                                .textFieldStyle(.plain)

                            Spacer()
                        }
                        .padding(.vertical, 6)
                        .listRowBackground(Color.clear)
                    }

                    // 空白セル（タップで新規タスク開始）
                    if !isAddingTask {
                        Color.clear
                            .frame(height: 80) // 適宜調整
                            .listRowBackground(Color.clear)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                isAddingTask = true
                                isInputActive = true
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
            }

            VStack {
                Spacer()
                HStack {
                    
                    // 🗑 左下 ゴミ箱ボタン
                    if !isAddingTask { // ← 編集中は非表示
                        Button {
                            viewModel.deleteCompletedTasks()
                        } label: {
                            Image(systemName: "trash")
                                .font(.title2)
                                .foregroundColor(.white)
                                .frame(width: 60, height: 60)
                                .background(Color(red: 60/255, green: 60/255, blue: 65/255)) // VSCode風黒グレー
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                        }
                    }
                    
                    Spacer()

                    // ➕ / ✅ 右下ボタン
                    Button {
                        if isAddingTask {
                            // 入力中 → チェックボタンで処理
                            if newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                                isAddingTask = false
                                newTaskTitle = ""
                                isInputActive = false
                            } else {
                                viewModel.addTask(title: newTaskTitle)
                                newTaskTitle = ""
                                isAddingTask = false
                                isInputActive = false
                            }
                        } else {
                            // 入力行表示
                            isAddingTask = true
                            isInputActive = true
                        }
                    } label: {
                        Image(systemName: isAddingTask ? "checkmark.circle.fill" : "plus") // 入力中はチェック
                            .font(.title)
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .background(Color(red: 60/255, green: 60/255, blue: 65/255))
                            .clipShape(Circle())
                            .shadow(color: .black.opacity(0.3), radius: 8, y: 4)
                    }
                }
                .padding()
            }
        }
        
    }

    private func addTask() {
        guard !newTaskTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        viewModel.addTask(title: newTaskTitle)
        newTaskTitle = ""
        isAddingTask = false
        isInputActive = false
    }
}

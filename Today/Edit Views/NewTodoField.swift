//
//  NewTodoField.swift
//  To-Day
//
//  Created by Sarah Reichelt on 16/2/2023.
//

import SwiftUI

struct NewTodoField: View {
  @EnvironmentObject var appState: AppState
  @State private var newTitle = ""
  @FocusState var newFieldHasFocus: Bool

  var body: some View {
    TextField("", text: $newTitle)
      .labelsHidden()
      .focused($newFieldHasFocus)
      .accessibilityLabel("Enter new to do and press Return")
      .onSubmit {
        // only works with Return
        if !newTitle.isEmpty {
          appState.createNewTodo(title: newTitle)
          newTitle = ""
        }
      }
      .onAppear {
        newFieldHasFocus = true
      }
  }
}

struct NewTodoField_Previews: PreviewProvider {
  static var previews: some View {
    NewTodoField()
      .environmentObject(AppState())
      .frame(width: 350)
  }
}

//
//  EditButtons.swift
//  To-Day
//
//  Created by Sarah Reichelt on 5/3/2023.
//

import SwiftUI

struct EditButtons: View {
  @EnvironmentObject var appState: AppState
  @State private var deleteButtonLabel = "Delete All…"
  @State private var askForDeleteConfirmation = true

  var body: some View {
    HStack {
      if #available(macOS 15.0, *) {
        deleteAllButtonWithOption
      } else {
        deleteAllConfirmButton
      }

      Spacer()

      Button("Mark All Incomplete") {
        appState.markAll(complete: false)
      }
      .disabled(appState.allIncomplete)
    }
    .padding([.horizontal, .bottom], 12)
  }

  var deleteAllConfirmButton: some View {
    Button(role: .destructive) {
      deleteAllTodos()
    } label: {
      Text("Delete All")
        .foregroundColor(.red)
        .opacity(appState.todos.isEmpty ? 0.5 : 1)
    }
    .disabled(appState.todos.isEmpty)
  }

  @available(macOS 15.0, *)
  var deleteAllButtonWithOption: some View {
    Button(role: .destructive) {
      deleteAllTodos()
    } label: {
      Text(deleteButtonLabel)
        .foregroundColor(.red)
        .opacity(appState.todos.isEmpty ? 0.5 : 1)
    }
    .help("Hold down Option to delete all without confirmation.")
    .onModifierKeysChanged(mask: .option, initial: false) { _, new in
      if new .isEmpty {
        deleteButtonLabel = "Delete All…"
        askForDeleteConfirmation = true
      } else {
        deleteButtonLabel = "Delete All"
        askForDeleteConfirmation = false
      }
    }
    .disabled(appState.todos.isEmpty)
  }

  func deleteAllTodos() {
    if askForDeleteConfirmation {
      appState.deleteAllWithConfirmation()
    } else {
      appState.deleteAll()
    }
  }
}

struct EditButtons_Previews: PreviewProvider {
  static var previews: some View {
    EditButtons()
      .environmentObject(AppState())
  }
}

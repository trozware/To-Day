//
//  EditView.swift
//  Today
//
//  Created by Sarah Reichelt on 18/1/2023.
//

//  TODO: keyboard shortcuts - requires list items to be selectable somehow

import SwiftUI

struct EditView: View {
  @ObservedObject var appState: AppState

  var body: some View {
    VStack {
      List {
        ForEach($appState.todos) { $todo in
          EditTodoView(appState: appState, todo: $todo)
        }

        NewTodoField(appState: appState)
      }
      .listStyle(.inset(alternatesRowBackgrounds: true))
      .environment(\.defaultMinListRowHeight, 30)

      Spacer()

      HStack {
        Button(role: .destructive) {
          appState.deleteAll()
        } label: {
          Text("Delete All")
            .foregroundColor(.red)
            .opacity(appState.todos.isEmpty ? 0.5 : 1)
        }
        .disabled(appState.todos.isEmpty)

        Spacer()

        Button("Mark All Incomplete") {
          appState.markAll(complete: false)
        }
        .disabled(appState.allIncomplete)
      }
      .padding([.horizontal, .bottom], 12)
    }
    .frame(minWidth: 350)
  }
}

struct EditView_Previews: PreviewProvider {
  static var previews: some View {
    EditView(appState: AppState())
      .frame(width: 350)
  }
}

//
//  TodayApp.swift
//  Today
//
//  Created by Sarah Reichelt on 16/1/2023.
//

import SwiftUI

@main
struct TodayApp: App {
  @StateObject var appState = AppState()

  var body: some Scene {
    MenuBarExtra {
      Group {
        appState.todoButtons

        EditGroup()

        SettingsGroup()

        AppGroup()
      }
      .environmentObject(appState)
    } label: {
      appState.menuTitle
    }

    Window("Edit Todos", id: "edit_todos") {
      EditView()
    }
    .defaultSize(width: 350, height: 400)

    Window("About To-Day", id: "about_today") {
      AboutView()
    }
    .defaultSize(width: 500, height: 630)
    .defaultPosition(.center)
    .windowResizability(.contentSize)
  }
}

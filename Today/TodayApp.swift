//
//  TodayApp.swift
//  Today
//
//  Created by Sarah Reichelt on 16/1/2023.
//

import SwiftUI
import ServiceManagement
import Sparkle

@main
struct TodayApp: App {
  @ObservedObject var appState = AppState()
  @Environment(\.openWindow) private var openWindow

  @State private var launchOnLogin = SMAppService.mainApp.status == .enabled
  private let updaterController: SPUStandardUpdaterController = SPUStandardUpdaterController(
    startingUpdater: true,
    updaterDelegate: nil,
    userDriverDelegate: nil
  )

  var body: some Scene {
    MenuBarExtra {
      appState.todoButtons

      Group {
        Divider()

        Button("Edit Todos…") {
          openWindow(id: "edit_todos")
          NSApp.activate(ignoringOtherApps: true)
        }

        Button("Mark All Complete") {
          appState.markAll(complete: true)
        }
        .disabled(appState.allComplete)

        Button("Mark All Incomplete") {
          appState.markAll(complete: false)
        }
        .disabled(appState.allIncomplete)
      }

      Group {
        Divider()

        Toggle("Completed at End", isOn: appState.$sortCompletedToEnd)

        Toggle("Launch on Login", isOn: $launchOnLogin)
      }

      Group {
        Divider()

        CheckForUpdatesView(updater: updaterController.updater)
        
        Button("About To-Day…") {
          openWindow(id: "about_today")
          NSApp.activate(ignoringOtherApps: true)
        }

        Button("Quit To-Day") {
          NSApp.terminate(nil)
        }
      }
    } label: {
      appState.menuTitle
    }
    .onChange(of: launchOnLogin) { _ in
      toggleLaunchOnLogin()
    }

    Window("Edit Todos", id: "edit_todos") {
      EditView(appState: appState)
    }
    .defaultSize(width: 350, height: 400)

    Window("About To-Day", id: "about_today") {
      AboutView()
    }
    .defaultSize(width: 350, height: 400)
  }
}

// MARK: - Launch on Login

extension TodayApp {
  func toggleLaunchOnLogin() {
    do {
      if SMAppService.mainApp.status == .enabled {
        try SMAppService.mainApp.unregister()
      } else {
        try SMAppService.mainApp.register()
      }
    } catch {
      print(error)
    }
  }
}

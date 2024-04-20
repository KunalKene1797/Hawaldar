//
//  HawaldarApp.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/1/24.
//

import SwiftUI
import SwiftData

@main
struct HawaldarApp: App {
    @AppStorage("isDarkMode") private var isDarkMode: Bool = true
    var body: some Scene {
        WindowGroup {
            MainView().preferredColorScheme(isDarkMode ? .dark : .light)
        }
        .modelContainer(for: AccountData.self)
    }
}

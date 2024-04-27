//
//  ContentView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/1/24.
//

import SwiftUI

struct MainView: View {
    
    @State var activeTab = 0
    @State private var oldSelectedItem = 0

    var body: some View {
        VStack{
            TabView(selection: $activeTab) {
                    AuthenticatorView().tabItem {
                    Image(systemName:"key.fill")
               Text("Authenticator") }.tag(0).onAppear { self.oldSelectedItem = self.activeTab }
                    SettingsView().tabItem { Text("Settings")
                    Image(systemName: "gear") }.tag(1).onAppear { self.oldSelectedItem = self.activeTab }
            }
        }
    }}

#Preview {
    MainView()
}

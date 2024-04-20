//
//  SettingsView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/6/24.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("isDarkMode") private var isDarkMode = true
    @State var darkMode: Bool = true;
    @Environment(\.modelContext) private var context

    var body: some View {
        NavigationStack{
            List{
                Section(header: Text("General").font(.footnote)){
                    NavigationLink("Appearance"){
                        List{
                            Section(header: Text("Theme")){
                                Button("Accent Color"){
                                    
                                }
                                Toggle(isOn: $isDarkMode){
                                    Text("Dark Mode")
                                }
                            }
                            
                            
                        }.navigationTitle("Appearance")
                        
                        
                    }
                    NavigationLink("About me"){
                        VStack{
                            Image(uiImage: UIImage(named: "AppIconTheme") ?? UIImage()).resizable().frame(width:90, height: 90).cornerRadius(20)
                            Text("HAWALDAR").padding(.top, 10).fontWeight(.bold)
                            Text("v 1.0").foregroundColor(.gray).fontWeight(.bold).font(.footnote)
                            VStack{
                                Text("Designed and Developed by")
                                Text("Kunal Kene")
                                    .font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }.padding().padding(.top,30)
                            VStack{
                                Text("Icon Pack by")
                                Text("Font Awesome")
                                    .font(.title2).fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            }.padding()
                        }.frame(maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .top).padding(.top, 15)
                    }
                    
                }
                Section(header:Text("Data")){
                    NavigationLink("Backup"){
                        Text("Coming soon")
                    }
                    Button{
                        try? context.delete(model: AccountData.self)
                    }label:{
                        Text("Wipe Data").foregroundColor(.red)
                    }
                }
                
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}

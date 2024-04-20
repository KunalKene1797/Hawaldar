//
//  NewAccountView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/13/24.
//

import SwiftUI
import CodeScanner
import FASwiftUI
import Combine
import SwiftData


struct NewAccountView: View {
    @State private var accountName: String = ""
    @State private var privateKey: String = ""
    @State private var keyTypes = ["Time Based", "Counter Based"]
    @State private var selectedKeyType: String = "Time Based"
    @State private var accountIcon: String = "apple"
    
    @State private var isShowingScanner:Bool
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    @Query private var currentAccountData: [AccountData]
    
    
    
    init(isShowingScanner: Bool = false, showAddView: Bool = false) {
        self.isShowingScanner = isShowingScanner
    }
        
    var body: some View {
        VStack{
            Text("Add New 2FA Account").padding(.vertical, 20).fontWeight(.bold)
            FAText(iconName: accountIcon, size: 60).padding(0)
            Form(){
                TextField("Account Name", text: $accountName)
                    .onChange(of: accountName){
                        if(!accountName.isEmpty){
                            accountIcon = accountName
                        }else{
                            accountIcon = "apple"
                        }
                    }
                HStack{
                    TextField("Private Key", text: $privateKey)
                    Button(){
                        isShowingScanner.toggle()
                    }label: {
                        Image(systemName: "camera").resizable().aspectRatio(contentMode: .fit).frame(height: 20)
                    }
                }.sheet(isPresented: $isShowingScanner, content: {
                    NavigationView{
                        ZStack{
                            CodeScannerView(codeTypes: [.qr]){
                                response in switch response{
                                case .success(let result):
                                    print("Found code: \(result.string)")
                                    isShowingScanner = false
                                    privateKey = result.string
                                case .failure(let error):
                                    print(error.localizedDescription)
                                    isShowingScanner = false
                                }
                            }
                            Image(systemName: "square.dashed").resizable().frame(width:300, height:300).fontWeight(.ultraLight).opacity(0.5)
                        }
                        
                    }
                    .presentationDragIndicator(.visible)
                    .presentationDetents([.medium])
                })
                
                
                Picker("Key Type", selection: $selectedKeyType){
                    ForEach(keyTypes, id:\.self){
                        Text($0)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .frame(height: 200)
            .scrollDisabled(true)
            Button("Add Account"){
                let newAccountData = AccountData(accountName: accountName, privateKey: privateKey, accountIcon: accountIcon, keyType: selectedKeyType, tokenCode: "111111")
                context.insert(newAccountData)
                dismiss()
            }.padding()
        }
    }
}

#Preview {
    NewAccountView()
}

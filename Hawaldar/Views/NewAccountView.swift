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


func getValueFromUrl(urlString: String, paramName: String) -> String? {
    guard let url = URL(string: urlString) else { return nil }
    let urlComponents = URLComponents(string: url.absoluteString)
    guard let queryItems = urlComponents?.queryItems else { return nil }
    return queryItems.first(where: { $0.name == paramName })?.value
}


struct NewAccountView: View {
    @State private var accountName: String = ""
    @State private var privateKey: String = ""
    @State private var identifier: String = ""
    @State private var keyTypes = ["Time Based", "Counter Based"]
    @State private var selectedKeyType: String = "Time Based"
    @State private var accountIcon: String = "apple"
    
    
    @State private var isShowingScanner:Bool
    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    // Variables
    private var navigationTitle: String = "Add New 2FA Account"
    private var buttonTitle: String = "Add Account"
    private var frameHeight: CGFloat = 320
    
    init(isShowingScanner: Bool = false) {
        self.isShowingScanner = isShowingScanner
    }
    
    var body: some View {
        VStack{
            Text(navigationTitle).padding(.vertical, 20).fontWeight(.bold)
            FAText(iconName: accountIcon, size: 60).padding(0)
            Form(){
                Section(footer: Text("Icons from Font Awesome")) {
                    TextField("Account Icon", text: $accountIcon)
                }
                TextField("Account Name", text: $accountName)
                    .onChange(of: accountName){
                        if(!accountName.isEmpty){
                            accountIcon = accountName
                        }else{
                            accountIcon = "apple"
                        }
                    }
                TextField("Email / Identifier (Optional)", text: $identifier)
                
                HStack{
                    TextField("Private Key", text: $privateKey)
                }
                .sheet(isPresented: $isShowingScanner, content: {
                    NavigationView{
                        ZStack{
                            CodeScannerView(codeTypes: [.qr]){
                                response in switch response{
                                case .success(let result):
                                    print("Found code: \(result.string)")
                                    isShowingScanner = false
                                    accountName = String(URL(string: result.string)!.path().dropFirst())
                                    privateKey = getValueFromUrl(urlString: result.string, paramName: "secret") ?? getValueFromUrl(urlString: result.string, paramName: "data") ?? privateKey
                                    
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
            .frame(height: frameHeight)
            .scrollDisabled(true)
            Button(buttonTitle){
                if(privateKey==""){
                    UINotificationFeedbackGenerator().notificationOccurred(.error)
                }else{
                    UINotificationFeedbackGenerator().notificationOccurred(.success)

                    let newAccountData = AccountData(accountName: accountName, privateKey: privateKey, identifier: identifier, accountIcon: accountIcon, keyType: selectedKeyType, tokenCode: "111111", isPinned: 0)
                    context.insert(newAccountData)
                    dismiss()
                }
                
            }.padding()
        }
    }
}

#Preview {
    NewAccountView()
}

//
//  EditAccountView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/27/24.
//

import SwiftUI
import FASwiftUI
import SwiftData

struct EditAccountView: View {
    // Variables
    private var navigationTitle: String = "Edit Account"
    private var buttonTitle: String = "Save"
    private var frameHeight: CGFloat = 240

    
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) var dismiss
    
    @Bindable var accountData: AccountData
    
    
    init(accountData: AccountData) {
        self.accountData = accountData
    }

    var body: some View {
        VStack{
            Text(navigationTitle).padding(.vertical, 20).fontWeight(.bold)
            FAText(iconName: accountData.accountIcon, size: 60).padding(0)
            Form(){
                Section(footer: Text("Icons from Font Awesome")) {
                    TextField("Account Icon", text: $accountData.accountIcon)
                }
                TextField("Account Name", text: $accountData.accountName)
                TextField("Email (Optional)", text: $accountData.identifier)

            }
            .scrollContentBackground(.hidden)
            .frame(height: frameHeight)
            .scrollDisabled(true)
            Button(buttonTitle){
                dismiss()
            }.padding()
        }
    }
}


#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: AccountData.self, configurations: config)
    let sampleAccountData = AccountData(accountName: "Apple", privateKey: "apple",identifier: "kunal.kene@icloud.com", accountIcon: "apple", keyType: "test", tokenCode: "111111", isPinned: 0)
    return EditAccountView(accountData: sampleAccountData)
        .modelContainer(container)
}

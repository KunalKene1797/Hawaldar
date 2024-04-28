//
//  AuthTablet.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/6/24.
//

import SwiftUI
import FASwiftUI
import UniformTypeIdentifiers
import SwiftData

struct AuthCodeView: View {
    
    var accountData: AccountData
    @Environment(\.modelContext) private var context
    var authCode: String
    @State var editAccountView = false
    @State private var accountDataToEdit: AccountData?

    private var circleSize = CGFloat(20)

    @State var authCodeOpacityVal: CGFloat = 1.0
    @State var authCodeScaleVal: CGFloat = 1.0
    @State var copiedOpacityVal: CGFloat = 0.0
    
    @ObservedObject var progressManager: ProgressManager
    
    init(accountData: AccountData, authCode: String, progressManager: ProgressManager) {
        self.accountData = accountData
        self.authCode = authCode
        self.progressManager = progressManager
    }
    var body: some View {
        
        ZStack{
            HStack{
                Image(systemName:"doc.on.doc").opacity(copiedOpacityVal)
                Text("COPIED").font(.title2).opacity(copiedOpacityVal)
            }.foregroundColor(.gray).tracking(3.0)
            
            HStack{
                FAText(iconName: accountData.accountIcon, size: 40)
                    .padding(.horizontal,10).frame(width: 60)
                
                
                VStack{
                    Text(accountData.accountName)
                        .font(.title3)
                        .fontWeight(.regular)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if(accountData.identifier != ""){
                        Text(verbatim:accountData.identifier)
                            .font(.footnote)
                            .lineLimit(1)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .tint(Color.primary).opacity(0.6)
                            .fontWeight(.semibold).disabled(true)
                    }
                    
                    
                    
                    
                    HStack{
                        Text(authCode.prefix(3))
                            .font(.largeTitle)
                            .fontWeight(.semibold).foregroundColor(Color("AccentColor")).tracking(2.0).padding(0).scaledToFit()
                        
                        Text(authCode.suffix(3))
                            .font(.largeTitle)
                            .fontWeight(.semibold).foregroundColor(Color("AccentColor")).tracking(2.0).padding(0).scaledToFit()
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                }
                ZStack{
                    Circle()
                        .stroke(lineWidth: circleSize)
                        .opacity(0.15)
                        .foregroundColor(.gray)
                        .frame(width: circleSize, height: circleSize)
                    
                    Circle()
                        .trim(from: 0.0, to: progressManager.progress)
                        .stroke(style: StrokeStyle(lineWidth: circleSize, lineCap: .butt, lineJoin: .round))
                        .rotationEffect(.degrees(270.0))
                        .foregroundColor(.accent)
                        .opacity(0.40)
                        .frame(width: circleSize, height: circleSize)
                }.padding(.trailing, 15)
                
            }.padding(.horizontal, 15.0).padding(.vertical, 5)
                .onTapGesture() {
                    withAnimation(.easeInOut(duration: 0.2)){
                        authCodeScaleVal = 0.9
                        authCodeOpacityVal = 0.1
                        copiedOpacityVal = 1.0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
                        withAnimation(.easeInOut(duration: 0.2)) {
                            authCodeScaleVal = 1.0
                            authCodeOpacityVal = 1.0
                            copiedOpacityVal = 0.0
                        }
                    }
                    //UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                    //showToast.toggle()
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    UIPasteboard.general.setValue(authCode, forPasteboardType: UTType.plainText.identifier )
                    print("Copied: ", String(authCode))
                }.opacity(authCodeOpacityVal)
                .scaleEffect(CGSize(width: authCodeScaleVal, height: authCodeScaleVal))
            
        }.contextMenu(ContextMenu(menuItems: {
            if(accountData.isPinned == 0){
                Button{
                    accountData.isPinned = 1
                }label:{
                    Image(systemName: "pin")
                    Text("Pin")
                }
            }else{
                Button{
                    accountData.isPinned = 0
                }label:{
                    Image(systemName: "pin.slash")
                    Text("Unpin")
                }
            }
            
            Button{
                accountDataToEdit = accountData
            }label:{
                Image(systemName:"pencil")
                Text("Edit")
            }
            Button{
                context.delete(accountData)
            }label:{
                Image(systemName: "trash").foregroundColor(.red)
                Text("Delete Item").foregroundColor(.red)
            }
            
        })).sheet(item: $accountDataToEdit) { accountData in
                NavigationView{
                    ZStack{
                        EditAccountView(accountData: accountData)
                    }
                }
                .presentationDetents([.height(440)]).presentationDragIndicator(.visible)
            }
        
    }
    
}



#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: AccountData.self, configurations: config)
    
    let sampleAccountData = AccountData(accountName: "Apple", privateKey: "apple",identifier: "kunal.kene@icloud.com", accountIcon: "apple", keyType: "test", tokenCode: "111111", isPinned: 0)
    
    let progressManager = ProgressManager()
            
    return AuthCodeView(accountData: sampleAccountData, authCode: "123456", progressManager: progressManager)
        .modelContainer(container)
}

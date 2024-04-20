//
//  AuthenticatorView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/6/24.
//

import SwiftUI
import SwiftData
import SwiftOTP

class Toast{
    @Published var showToast = false
}

class CodeReset: ObservableObject {
    @Published var timer: Timer?
    @Published var refresh: Bool = false

    init(){
        timer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true, block: { Timer in
            self.refresh.toggle()
        })
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct AuthenticatorView: View {
    @State var showToast = Toast().showToast
    @State private var animationCount = 1
    @State private var showCamera = false
    @State private var showAddView = false
    @Query private var accountData: [AccountData]
    @StateObject var codeReset = CodeReset()
        
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    if(codeReset.refresh){
                        // Nothing
                    }
                    ForEach(accountData){item in
                        AuthCodeView(accountData: item, authCode: TOTP(secret: base32DecodeToData(item.privateKey) ?? Data(hex: "1"))?.generate(time: Date.now) ?? "111111")
                        if(item != accountData.last){
                            Divider().padding(.horizontal,20)
                        }
                    }
                }
                .padding(.top, 10)
                .navigationTitle("Hawaldar")
                .toolbar(content: {
                    
                    Button{
                        showCamera.toggle()
                    }label:{
                        Image(systemName: "camera").foregroundStyle(.accent)
                    }.sheet(isPresented: $showCamera){
                        NavigationView{
                            NewAccountView(isShowingScanner: true)
                        }.presentationDetents([.height(450)]).presentationDragIndicator(.visible)
                    }
                    
                    Button{
                        animationCount += 1
                        showAddView.toggle()
                        // Action
                    }label:{
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                            .foregroundStyle(.accent).symbolEffect(
                                .bounce,
                                value: animationCount
                            )
                    }.sheet(isPresented: $showAddView){
                        NavigationView{
                            NewAccountView()
                        }.presentationDetents([.height(450)]).presentationDragIndicator(.visible)
                    }
                    
                })
            }.refreshable {
                print("Refreshed")
            }
        }
        
    }
}

#Preview {
    AuthenticatorView()
}

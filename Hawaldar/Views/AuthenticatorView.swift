//
//  AuthenticatorView.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/6/24.
//

import SwiftUI
import SwiftData
import SwiftOTP

struct AuthenticatorView: View {
    @State private var animationCount = 1
    @State private var showCamera = false
    @State private var showAddView = false
    @Query(sort: \AccountData.isPinned, order: .reverse) private var accountData: [AccountData]
    @StateObject var progressManager = ProgressManager()
    
    var body: some View {
        NavigationView{
            ScrollView{
                VStack{
                    if(progressManager.refresh){
                        // Nothing
                    }
                    ForEach(accountData){item in
                        AuthCodeView(accountData: item, authCode: TOTP(secret: base32DecodeToData(item.privateKey) ?? Data(hex: "1"))?.generate(time: Date.now) ?? "111111", progressManager: progressManager)
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
                        }.presentationDetents([.height(460)]).presentationDragIndicator(.visible)
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
                        }.presentationDetents([.height(550)]).presentationDragIndicator(.visible)
                    }
                    
                })
            }.refreshable {
                print("Refreshed")
            }
        }
        
    }
}

class ProgressManager: ObservableObject {
    @Published var progress: CGFloat
    @Published var refresh: Bool = false
    private var timer: Timer?
    
    init(progress: CGFloat = currentTimeAsFloat()) {
        self.progress = progress
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.progress += 0.0333333
            if self.progress >= 1.0{
                self.progress = currentTimeAsFloat()
                self.refresh.toggle()
            }
        }
    }
    
    deinit {
        timer?.invalidate()
    }
}

func currentTimeAsFloat() -> CGFloat {
  let calendar = Calendar.current
  let now = Date()
  let components = calendar.dateComponents([.minute, .second], from: now)

  guard let minute = components.minute, let second = components.second else { return 0.0 }

  // Calculate total seconds elapsed in the current minute
  let elapsedSeconds = CGFloat(minute) * 60.0 + CGFloat(second)

  // Normalize to value between 0.0 and 1.0 within a 30-second cycle
  let normalizedTime = fmod(elapsedSeconds, 30.0) / 30.0

  return normalizedTime
}


#Preview {
    AuthenticatorView()
}

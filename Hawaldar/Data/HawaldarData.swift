//
//  HawaldarData.swift
//  Hawaldar
//
//  Created by Kunal Kene on 4/13/24.
//

import Foundation
import SwiftData

@Model
class AccountData{
    var accountName: String
    var privateKey: String
    var accountIcon: String
    var keyType: String
    var tokenCode: String
    
    init(accountName: String, privateKey: String, accountIcon: String, keyType: String, tokenCode: String) {
        self.accountName = accountName
        self.privateKey = privateKey
        self.accountIcon = accountIcon
        self.keyType = keyType
        self.tokenCode = tokenCode
    }
}

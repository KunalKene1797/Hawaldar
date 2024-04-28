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
    @Attribute(.unique) var privateKey: String
    var identifier: String
    var accountIcon: String
    var keyType: String
    var tokenCode: String
    var isPinned: UInt8
    
    init(accountName: String, privateKey: String, identifier: String, accountIcon: String, keyType: String, tokenCode: String, isPinned: UInt8) {
        self.accountName = accountName
        self.privateKey = privateKey
        self.identifier = identifier
        self.accountIcon = accountIcon
        self.keyType = keyType
        self.tokenCode = tokenCode
        self.isPinned = isPinned
    }
}

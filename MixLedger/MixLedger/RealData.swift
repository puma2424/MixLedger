//
//  RealData.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/19.
//

import Foundation

class SaveData{
    static let shared = SaveData()
    
    var accountData: TransactionsResponse?
    var userInfoData: [String : UsersInfoResponse] = [:]
    var myInfo: UsersInfoResponse?
    var myShareAccount: [String : String] = [:]
//    var accountInfo:
}
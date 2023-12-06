//
//  Allicon.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import Foundation
import UIKit

enum AllIcons: String, CaseIterable {
    case add
    case add2
    case bookAndPencil
    case calendar
    case fundAccounting
    case human
    case more
    case share
    case storytelling
    case wallet
    case icons8Back
    case edit
    case checkmark
    case close
    case person
    case foodRice
    case moneyAndCoin
    case icons8Chart
    case settingsMale
    
    var icon: UIImage? {
        return UIImage(named: rawValue)
    }
}

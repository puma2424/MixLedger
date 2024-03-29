//
//  Allicon.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import Foundation
import UIKit

// model
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
    case educate
    case foodFish
    case foodCake
    case foodVegetables
    case game
    case medical
    case foodHamburger
    case house
    case pet
    case traffic
    case medical2
    case drink
    case daily
    case beauty
    case dress
    case social
    case eProduct
    case receipt
    case date
    case qrcode
    case share2
    case importIcon
    case cashInHand

    var icon: UIImage? {
        return UIImage(named: rawValue)
    }
}

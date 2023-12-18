//
//  SubTypeIconModel.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/8.
//

import Foundation
import UIKit

struct IconGroup {
    let items: [IconItemProtocol]
}

protocol IconItemProtocol {
    var image: UIImage? { get }
    var title: String { get }
    var name: String { get }
}

enum UserImageItem: IconItemProtocol, CaseIterable {
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

    static func item(_ string: String) -> UserImageItem? {
        return UserImageItem.allCases.first(where: { $0.name == string })
    }

    var image: UIImage? {
        switch self {
        case .educate:
            return UIImage(named: AllIcons.educate.rawValue)
        case .foodCake:
            return UIImage(named: AllIcons.foodCake.rawValue)
        case .foodVegetables:
            return UIImage(named: AllIcons.foodVegetables.rawValue)
        case .game:
            return UIImage(named: AllIcons.game.rawValue)
        case .foodHamburger:
            return UIImage(named: AllIcons.foodHamburger.rawValue)
        case .house:
            return UIImage(named: AllIcons.house.rawValue)
        case .pet:
            return UIImage(named: AllIcons.pet.rawValue)
        case .drink:
            return UIImage(named: AllIcons.drink.rawValue)
        case .traffic:
            return UIImage(named: AllIcons.traffic.rawValue)
        case .medical2:
            return UIImage(named: AllIcons.medical2.rawValue)
        case .daily:
            return UIImage(named: AllIcons.daily.rawValue)
        case .beauty:
            return UIImage(named: AllIcons.beauty.rawValue)
        case .dress:
            return UIImage(named: AllIcons.dress.rawValue)
        case .social:
            return UIImage(named: AllIcons.social.rawValue)
        case .eProduct:
            return UIImage(named: AllIcons.eProduct.rawValue)
        case .add:
            return UIImage(named: AllIcons.add.rawValue)
        case .add2:
            return UIImage(named: AllIcons.add2.rawValue)
        case .bookAndPencil:
            return UIImage(named: AllIcons.bookAndPencil.rawValue)
        case .calendar:
            return UIImage(named: AllIcons.calendar.rawValue)
        case .fundAccounting:
            return UIImage(named: AllIcons.fundAccounting.rawValue)
        case .human:
            return UIImage(named: AllIcons.human.rawValue)
        case .more:
            return UIImage(named: AllIcons.more.rawValue)
        case .share:
            return UIImage(named: AllIcons.share.rawValue)
        case .storytelling:
            return UIImage(named: AllIcons.storytelling.rawValue)
        case .wallet:
            return UIImage(named: AllIcons.wallet.rawValue)
        case .icons8Back:
            return UIImage(named: AllIcons.icons8Back.rawValue)
        case .edit:
            return UIImage(named: AllIcons.edit.rawValue)
        case .checkmark:
            return UIImage(named: AllIcons.checkmark.rawValue)
        case .close:
            return UIImage(named: AllIcons.close.rawValue)
        case .person:
            return UIImage(named: AllIcons.person.rawValue)
        case .foodRice:
            return UIImage(named: AllIcons.foodRice.rawValue)
        case .moneyAndCoin:
            return UIImage(named: AllIcons.moneyAndCoin.rawValue)
        case .icons8Chart:
            return UIImage(named: AllIcons.icons8Chart.rawValue)
        case .settingsMale:
            return UIImage(named: AllIcons.settingsMale.rawValue)
        case .foodFish:
            return UIImage(named: AllIcons.foodFish.rawValue)
        case .medical:
            return UIImage(named: AllIcons.medical.rawValue)
        case .receipt:
            return UIImage(named: AllIcons.receipt.rawValue)
        case .date:
            return UIImage(named: AllIcons.date.rawValue)
        case .qrcode:
            return UIImage(named: AllIcons.qrcode.rawValue)
        case .share2:
            return UIImage(named: AllIcons.share2.rawValue)
        case .importIcon:
            return UIImage(named: AllIcons.importIcon.rawValue)
        case .cashInHand:
            return UIImage(named: AllIcons.cashInHand.rawValue)
        }
    }

    var title: String {
        switch self {
        case .educate:
            return "Educate"
        case .foodCake:
            return "Dessert"
        case .foodVegetables:
            return "Ingredients"
        case .game:
            return "Game"
        case .foodHamburger:
            return "Food"
        case .house:
            return "Residential"
        case .pet:
            return "Pet"
        case .drink:
            return "Drink"
        case .traffic:
            return "Traffic"
        case .medical2:
            return "Medical"
        case .daily:
            return "Daily"
        case .beauty:
            return "Beauty"
        case .dress:
            return "Dress"
        case .social:
            return "Social"
        case .eProduct:
            return "eProduct"
        case .add:
            return "Add"
        case .add2:
            return "Add2"
        case .bookAndPencil:
            return "Book & Pencil"
        case .calendar:
            return "Calendar"
        case .fundAccounting:
            return "Fund Accounting"
        case .human:
            return "Human"
        case .more:
            return "More"
        case .share:
            return "Share"
        case .storytelling:
            return "Storytelling"
        case .wallet:
            return "Wallet"
        case .icons8Back:
            return "Back"
        case .edit:
            return "Edit"
        case .checkmark:
            return "Checkmark"
        case .close:
            return "Close"
        case .person:
            return "Person"
        case .foodRice:
            return "Rice"
        case .moneyAndCoin:
            return "Money & Coin"
        case .icons8Chart:
            return "Chart"
        case .settingsMale:
            return "Male"
        case .foodFish:
            return "Fish"
        case .medical:
            return "Medical"
        case .receipt:
            return "Receipt"
        case .date:
            return "Date"
        case .qrcode:
            return "QRCode"
        case .share2:
            return "Share2"
        case .importIcon:
            return "Import"
        case .cashInHand:
            return "Cash in Hand"
        }
    }

    var name: String {
        switch self {
        case .educate:
            return AllIcons.educate.rawValue
        case .foodCake:
            return AllIcons.foodCake.rawValue
        case .foodVegetables:
            return AllIcons.foodVegetables.rawValue
        case .game:
            return AllIcons.game.rawValue
        case .foodHamburger:
            return AllIcons.foodHamburger.rawValue
        case .house:
            return AllIcons.house.rawValue
        case .pet:
            return AllIcons.pet.rawValue
        case .drink:
            return AllIcons.drink.rawValue
        case .traffic:
            return AllIcons.traffic.rawValue
        case .medical2:
            return AllIcons.medical2.rawValue
        case .daily:
            return AllIcons.daily.rawValue
        case .beauty:
            return AllIcons.beauty.rawValue
        case .dress:
            return AllIcons.dress.rawValue
        case .social:
            return AllIcons.social.rawValue
        case .eProduct:
            return AllIcons.eProduct.rawValue
        case .add:
            return AllIcons.add.rawValue
        case .add2:
            return AllIcons.add2.rawValue
        case .bookAndPencil:
            return AllIcons.bookAndPencil.rawValue
        case .calendar:
            return AllIcons.calendar.rawValue
        case .fundAccounting:
            return AllIcons.fundAccounting.rawValue
        case .human:
            return AllIcons.human.rawValue
        case .more:
            return AllIcons.more.rawValue
        case .share:
            return AllIcons.share.rawValue
        case .storytelling:
            return AllIcons.storytelling.rawValue
        case .wallet:
            return AllIcons.wallet.rawValue
        case .icons8Back:
            return AllIcons.icons8Back.rawValue
        case .edit:
            return AllIcons.edit.rawValue
        case .checkmark:
            return AllIcons.checkmark.rawValue
        case .close:
            return AllIcons.close.rawValue
        case .person:
            return AllIcons.person.rawValue
        case .foodRice:
            return AllIcons.foodRice.rawValue
        case .moneyAndCoin:
            return AllIcons.moneyAndCoin.rawValue
        case .icons8Chart:
            return AllIcons.icons8Chart.rawValue
        case .settingsMale:
            return AllIcons.settingsMale.rawValue
        case .foodFish:
            return AllIcons.foodFish.rawValue
        case .medical:
            return AllIcons.medical.rawValue
        case .receipt:
            return AllIcons.receipt.rawValue
        case .date:
            return AllIcons.date.rawValue
        case .qrcode:
            return AllIcons.qrcode.rawValue
        case .share2:
            return AllIcons.share2.rawValue
        case .importIcon:
            return AllIcons.importIcon.rawValue
        case .cashInHand:
            return AllIcons.cashInHand.rawValue
        }
    }
}

enum SubTypeItem: IconItemProtocol, CaseIterable {
    case foodHamburger
    case educate
    case foodCake
    case foodVegetables
    case game
    case house
    case pet
    case drink
    case traffic
    case medical2
    case daily
    case beauty
    case dress
    case social
    case eProduct

    static func item(forTitle title: String) -> SubTypeItem? {
        return SubTypeItem.allCases.first { $0.title == title }
    }

    var image: UIImage? {
        switch self {
        case .educate:
            return UIImage(named: AllIcons.educate.rawValue)
        case .foodCake:
            return UIImage(named: AllIcons.foodCake.rawValue)
        case .foodVegetables:
            return UIImage(named: AllIcons.foodVegetables.rawValue)
        case .game:
            return UIImage(named: AllIcons.game.rawValue)
        case .foodHamburger:
            return UIImage(named: AllIcons.foodHamburger.rawValue)
        case .house:
            return UIImage(named: AllIcons.house.rawValue)
        case .pet:
            return UIImage(named: AllIcons.pet.rawValue)
        case .drink:
            return UIImage(named: AllIcons.drink.rawValue)
        case .traffic:
            return UIImage(named: AllIcons.traffic.rawValue)
        case .medical2:
            return UIImage(named: AllIcons.medical2.rawValue)
        case .daily:
            return UIImage(named: AllIcons.daily.rawValue)
        case .beauty:
            return UIImage(named: AllIcons.beauty.rawValue)
        case .dress:
            return UIImage(named: AllIcons.dress.rawValue)
        case .social:
            return UIImage(named: AllIcons.social.rawValue)
        case .eProduct:
            return UIImage(named: AllIcons.eProduct.rawValue)
        }
    }

    var title: String {
        switch self {
//        case .awaitingPayment: return NSLocalizedString("待付款")
        case .educate:
            return "Educate"
        case .foodCake:
            return "Dessert"
        case .foodVegetables:
            return "Ingredients"
        case .game:
            return "Game"
        case .foodHamburger:
            return "Food"
        case .house:
            return "Residential"
        case .pet:
            return "Pet"
        case .drink:
            return "Drink"
        case .traffic:
            return "Traffic"
        case .medical2:
            return "Medical"
        case .daily:
            return "Daily"
        case .beauty:
            return "Beauty"
        case .dress:
            return "Dress"
        case .social:
            return "Social"
        case .eProduct:
            return "eProduct"
        }
    }

    var name: String {
        switch self {
        case .educate:
            return AllIcons.educate.rawValue
        case .foodCake:
            return AllIcons.foodCake.rawValue
        case .foodVegetables:
            return AllIcons.foodVegetables.rawValue
        case .game:
            return AllIcons.game.rawValue
        case .foodHamburger:
            return AllIcons.foodHamburger.rawValue
        case .house:
            return AllIcons.house.rawValue
        case .pet:
            return AllIcons.pet.rawValue
        case .drink:
            return AllIcons.drink.rawValue
        case .traffic:
            return AllIcons.traffic.rawValue
        case .medical2:
            return AllIcons.medical2.rawValue
        case .daily:
            return AllIcons.daily.rawValue
        case .beauty:
            return AllIcons.beauty.rawValue
        case .dress:
            return AllIcons.dress.rawValue
        case .social:
            return AllIcons.social.rawValue
        case .eProduct:
            return AllIcons.eProduct.rawValue
        }
    }
}

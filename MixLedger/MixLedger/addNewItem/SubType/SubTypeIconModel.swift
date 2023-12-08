//
//  SubTypeIconModel.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/8.
//

import Foundation
import UIKit

protocol SubTypeItemProtocol {
    var image: UIImage? { get }
    var title: String { get }
    var name: String { get }
}

enum SubTypeItem: SubTypeItemProtocol, CaseIterable  {
    
    case foodHamburger
    case educate
    case foodCake
    case foodVegetables
    case game
    case medical
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
        case .medical:
            return UIImage(named: AllIcons.medical.rawValue)
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
        case .medical:
            return "Medical"
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
            return "Medical2"
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
        case .medical:
            return AllIcons.medical.rawValue
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

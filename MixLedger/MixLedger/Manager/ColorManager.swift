//
//  ColorManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/6.
//

import Foundation
import SwiftUI


class ColorManager {
    let shared = ColorManager()
    
    static func getAllColors() -> [Color] {
        return [
            Color.blue1,
            Color.blue2,
            Color.brightGreen1,
            Color.brightGreen2,
            Color.brightGreen3,
            Color.brightGreen4,
            Color.gray1,
            Color.gray2,
            Color.yellow1,
            Color.yellow2,
            Color.red1,
            Color.red2,
            Color.mint1,
            Color.mint2,
            Color.purple1,
            Color.purple2,
            Color.orange1,
            Color.orange2,
            Color.pink1,
            Color.pink2
        ]
    }
}

//
//  Array+Extension.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2024/1/1.
//

import Foundation
import SwiftUI

extension Array where Self.Element == Color {
    static func getAllColors() -> [Color] {
        return [
            Color.red1,
            Color.red2,
            
            Color.yellow1,
            Color.yellow2,

            Color.mint1,
            Color.mint2,
            
            Color.purple1,
            Color.purple2,
            
            Color.orange1,
            Color.orange2,
            
            Color.pink1,
            Color.pink2,
            
            Color.gray1,
            
            Color.blue1,
            
            Color.brightGreen1,
            Color.brightGreen3
        ]
    }
}

//
//  SelectIconManager.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/12/17.
//

import Foundation

class SelectIconManager {
    let subTypeGroup: IconGroup = .init(
        items: SubTypeItem.allCases
    )

    let userIconGroup = IconGroup(
        items: UserImageItem.allCases
    )

    lazy var groups: [IconGroup] = [subTypeGroup, userIconGroup]
}

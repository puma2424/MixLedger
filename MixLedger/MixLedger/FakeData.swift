//
//  fake data.swift
//  MixLedger
//
//  Created by 莊羚羊 on 2023/11/17.
//

import Foundation
import UIKit

struct BillTag{
    var icon: UIImage?
    var name: String
}

var billArray: [[String: [Any]]] = [["日期": [Date()],
                                     "item": [["金額": -3000000,
                                               "付費者": ["puma","niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓欸",
                                               "幣別": "新台幣",
                                               "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from":""],
                                              ["金額": -300,
                                               "付費者": ["puma","niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                               "幣別": "新台幣",
                                               "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from":""]]
                                    ],
                                    ["日期": [Date()],
                                     "item": [["金額": 3000000,
                                               "付費者": ["puma","niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓欸",
                                               "幣別": "新台幣",
                                               "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from":""],
                                              ["金額": 300,
                                               "付費者": ["puma","niw"],
                                               "分費者": ["puma"],
                                               "備註": "草莓好好吃誒誒誒誒誒誒誒誒誒誒欸誒誒誒誒誒誒誒誒誒",
                                               "幣別": "新台幣",
                                               "類型": BillTag(icon: UIImage(named: "more"), name: "飲食"),
                                               "照片": UIImage(named: "more"),
                                               "from":""]]
                                    ]
]

var allAccount: [[String: Any]] = [["name": "我的帳本",
                                 "iconName": AllIcons.bookAndPencil.rawValue],
                                   ["name": "嘉義好好玩",
                                    "iconName": AllIcons.human.rawValue]]

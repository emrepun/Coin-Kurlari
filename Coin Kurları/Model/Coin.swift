//
//  Coin.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 21.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Coin {
    let name: String
    let price_usd: String
    let percent_change_24h: String
    
    init(userJson: JSON) {
        
        self.name = userJson[0]["name"].stringValue
        self.price_usd = userJson[0]["price_usd"].stringValue
        self.percent_change_24h = userJson[0]["percent_change_24h"].stringValue
    }
}

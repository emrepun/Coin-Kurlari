//
//  CoinCell.swift
//  Coin Kurları
//
//  Created by Emre HAVAN on 21.12.2017.
//  Copyright © 2017 Emre HAVAN. All rights reserved.
//

import UIKit

class CoinCell: UITableViewCell {

    @IBOutlet weak var coinLabel: UILabel!
    @IBOutlet weak var tlLabel: UILabel!
    @IBOutlet weak var dollarLabel: UILabel!
    @IBOutlet weak var euroLabel: UILabel!
    @IBOutlet weak var percentageLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

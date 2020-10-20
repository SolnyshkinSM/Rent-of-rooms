//
//  ClientDetailTableViewCell.swift
//  Rent of rooms
//
//  Created by Administrator on 05.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class ClientDetailTableViewCell: UITableViewCell {

    @IBOutlet var keyLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

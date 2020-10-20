//
//  ContractTableViewCell.swift
//  Rent of rooms
//
//  Created by Administrator on 07.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class ContractTableViewCell: UITableViewCell {

    @IBOutlet var imageViewContract: UIImageView!
    @IBOutlet var numberLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var roomLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

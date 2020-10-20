//
//  PaymentTableViewCell.swift
//  Rent of rooms
//
//  Created by Administrator on 08.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class PaymentTableViewCell: UITableViewCell {

    @IBOutlet var imageViewPayment: UIImageView!
    @IBOutlet var clientLabel: UILabel!
    @IBOutlet var contractLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var sumLabel: UILabel!    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

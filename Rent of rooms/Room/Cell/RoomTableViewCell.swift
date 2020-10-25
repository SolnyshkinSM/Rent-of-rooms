//
//  RoomTableViewCell.swift
//  Rent of rooms
//
//  Created by Administrator on 23.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

@IBDesignable
class RoomTableViewCell: UITableViewCell {

    @IBOutlet var imageViewRoom: UIImageView!
    @IBOutlet var textLabelRoom: UILabel!
    @IBOutlet var detailTextLabelRoom: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  ClientTableViewCell.swift
//  Rent of rooms
//
//  Created by Administrator on 06.10.2020.
//  Copyright © 2020 Administrator. All rights reserved.
//

import UIKit

class ClientTableViewCell: UITableViewCell {

    @IBOutlet var imageViewCell: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var adressLabel: UILabel!
    @IBOutlet var phoneLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureCell()
    }
    
    // MARK: - Methods
    
    func configureCell() {
        imageViewCell.layer.cornerRadius = imageViewCell.bounds.width / 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

//
//  GuestCellTableViewCell.swift
//  My Project
//
//  Created by susanne on 2020/5/13.
//  Copyright © 2020 Mike Wu. All rights reserved.
//

import UIKit

class GuestCellTableViewCell: UITableViewCell {
    @IBOutlet var titleTextLabel: UILabel!
    @IBOutlet var subtitleTextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

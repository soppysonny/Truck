//
//  NewsTitleTableViewCell.swift
//  Truck
//
//  Created by zhangming on 2020/11/9.
//  Copyright © 2020 Binada. All rights reserved.
//

import UIKit

class NewsTitleTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var timeLable: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

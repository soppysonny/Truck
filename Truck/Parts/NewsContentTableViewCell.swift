//
//  NewsContentTableViewCell.swift
//  Truck
//
//  Created by zhangming on 2020/11/9.
//  Copyright © 2020 Binada. All rights reserved.
//

import UIKit

class NewsContentTableViewCell: UITableViewCell {

    @IBOutlet weak var contentLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        contentLb.text = ""
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

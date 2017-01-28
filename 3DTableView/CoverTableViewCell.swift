//
//  CoverTableViewCell.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/22.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit

class CoverTableViewCell: UITableViewCell {

    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

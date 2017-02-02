//
//  DiscoverTableViewCell.swift
//  3DTableView
//
//  Created by Wu KD on 2017/2/2.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit

class DiscoverTableViewCell: UITableViewCell {
    
    
    @IBOutlet var nameField: UILabel!
    @IBOutlet var locationField: UILabel!
    @IBOutlet var phoneField: UILabel!
    @IBOutlet var webField: UILabel!
    @IBOutlet var thumbImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    


}

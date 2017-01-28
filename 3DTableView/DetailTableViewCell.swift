//
//  DetailTableViewCell.swift
//  3DTableView
//
//  Created by Wu KD on 2017/1/24.
//  Copyright © 2017年 Kuangder. All rights reserved.
//

import UIKit



class DetailTableViewCell: UITableViewCell {

    @IBOutlet var fieldLabel: UILabel!
    @IBOutlet var valueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

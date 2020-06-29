//
//  BaseCell.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/29.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class BaseCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func parseData(_ data: Any) {
       
    }
    
    func parseData(_ data: Any, indexPath: IndexPath) {
       
    }
}

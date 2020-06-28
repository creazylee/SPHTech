//
//  ChartListCell.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class ChartListCell: UITableViewCell {

    @IBOutlet weak var mValueLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func parseData(_ data: Any) {
        let model: ChartRecordsModel = data as! ChartRecordsModel;
        self.mTitleLabel.text = model.quarter;
        self.mValueLabel.text = model.volume_of_mobile_data;
    }
    
}

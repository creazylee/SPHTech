//
//  ChartListCell.swift
//  SPHTech
//
//  Created by creazylee on 2020/6/28.
//  Copyright © 2020 creazylee. All rights reserved.
//

import UIKit

class ChartListCell: BaseCell {

    @IBOutlet weak var mValueLabel: UILabel!
    @IBOutlet weak var mTitleLabel: UILabel!
    @IBOutlet weak var mDeclineImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(tapDeclineImageView(tapGesture:)))
        self.mDeclineImageView.addGestureRecognizer(tapGesture)
        self.mDeclineImageView.isUserInteractionEnabled = true
    }
    
    @objc func tapDeclineImageView(tapGesture: UITapGestureRecognizer) {
        print("下降")
        let tapView = tapGesture.view
        let index = tapView?.tag ?? 0
        let alertController = UIAlertController.init(title: "提示", message: String.init(format: "您点击了下降警示，位于%d行", index+1), preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "确定", style: .default, handler: nil)
        alertController.addAction(okAction)
        UIApplication.shared.keyWindow?.rootViewController?.present(alertController, animated: true, completion: nil)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func parseData(_ data: Any) {
        
    }
    
    override func parseData(_ data: Any, indexPath: IndexPath) {
        self.mDeclineImageView.isHidden = true
        self.mDeclineImageView.tag = indexPath.row
        if data is Array<ChartRecordsModel> {
            let dataAry: Array<ChartRecordsModel> = data as! Array<ChartRecordsModel>
            let model: ChartRecordsModel = dataAry[indexPath.row];
            self.mTitleLabel.text = model.quarter;
            self.mValueLabel.text = model.volume_of_mobile_data;
            
            if indexPath.row != 0 && dataAry.count > 1 {
                let preModel = dataAry[indexPath.row - 1]
                //判断数据下降则显示提示
                if model.volume_of_mobile_data.toFloat() < preModel.volume_of_mobile_data.toFloat() {
                    self.mDeclineImageView.isHidden = false
                }
            }
        }else {
            self.mTitleLabel.text = "";
            self.mValueLabel.text = "";
        }
        
    }
    
}

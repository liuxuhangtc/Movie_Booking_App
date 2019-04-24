//
//  TransferCell.swift
//
//  Created by Xuhang Liu on 2019/4/10.
//  Copyright © 2019 Xuhang Liu. All rights reserved.
//

import UIKit

class TransferCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    static var height: CGFloat =  62
    
    
    /// amount    交易金额    finishTime    交易完成时间    direct    出入金     balance    交易后余额     tradeType    交易类型    bizOrderNo    业务流水号    userNo    用户编码
    var info: JSONMap = [:] {
        didSet {
            if info.count > 0 {
                titleLabel.text = info["tradeType"] as? String
                dateLabel.text = info["finishTime"] as? String
                if let value = info["balance"] as? String {
                    balanceLabel.text = "余额：\(value)"
                }
                if let direct = info["direct"] as? String, let amount = info["amount"] as? String {
                    amountLabel.text = (direct == "IN" ? "+": "-" ) + amount
                }
                
            }
        }
    }
}

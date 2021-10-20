//
//  AdCell.swift
//  HeiAd
//
//  Created by Reinhard D on 20.10.21.
//


import UIKit

class AdCell: UITableViewCell {
    
    @IBOutlet var titleText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var locationText: UILabel!
    @IBOutlet var adImage: UIImageView!
    @IBOutlet var faveButton: UIButton!
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}

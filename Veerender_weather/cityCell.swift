//
// cityCell.swift
//  Veerender_weather
//
//  Created by macbook on 16/04/21.
//  Copyright © 2021 Cloudsolv. All rights reserved.
//

import UIKit

class cityCell: UITableViewCell {
    
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var degreeLbl: UILabel!
    @IBOutlet weak var bgImg: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

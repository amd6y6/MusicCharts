//
//  MusicTableViewCell.swift
//  MusicCharts
//
//  Created by Austin Dotto on 7/26/18.
//  Copyright © 2018 Austin Dotto. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
  
    
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var trackName: UILabel!
    @IBOutlet weak var albumImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

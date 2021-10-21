//
//  ListTableViewCell.swift
//  Pythagorean
//
//  Created by Ioannis on 12/3/21.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    
    @IBOutlet weak var imgInCell: UIImageView!
    @IBOutlet weak var lblInCell: UILabel!
    @IBOutlet weak var lblDateInCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        lblInCell.lineBreakMode = .byWordWrapping
        lblInCell.numberOfLines = 0
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
   
    

}//Class

//
//  DisplayTutorialCell.swift
//  AnimeDraw
//
//  Created by paxcreation on 12/14/20.
//

import UIKit

class DisplayTutorialCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbContent: UILabel!
    @IBOutlet weak var hLabel: NSLayoutConstraint!
    @IBOutlet weak var hImage: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

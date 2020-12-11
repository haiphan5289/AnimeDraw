//
//  StepCell.swift
//  AnimeDraw
//
//  Created by haiphan on 12/5/20.
//

import UIKit

class StepCell: UICollectionViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lbName.adjustsFontSizeToFitWidth = true
        lbName.minimumScaleFactor = 0.5
    }

}

//
//  RecognizedUserTableViewCell.swift
//  What I See
//
//  Created by ibrahim al-khatib on 3/27/17.
//  Copyright © 2017 ibrahim al-khatib. All rights reserved.
//

import UIKit

class RecognizedUserTableViewCell: UITableViewCell {

    @IBOutlet weak var recognizedUserNameLabel: UILabel!
    @IBOutlet weak var recognizedUserRelationLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        recognizedUserNameLabel.text = nil
        recognizedUserRelationLabel.text = nil
    }

    func prepare(recognizedUser: RecognizedUserModel) {
        recognizedUserNameLabel.text = recognizedUser.name
        recognizedUserRelationLabel.text = recognizedUser.relation ?? ""
    }
}

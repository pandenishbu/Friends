//
//  ConversationTableViewCell.swift
//  Friends
//
//  Created by Mary Milchenko on 25.02.2019.
//  Copyright © 2019 Pandenishbu. All rights reserved.
//

import UIKit

protocol MessageCellConfiguration : class{
    var message : String? {get set}
}

class ConversationTableViewCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(
        message: String){
        self.message = message
    }
    
}

extension ConversationTableViewCell: MessageCellConfiguration {
    
    var message: String? {
        get {
            return self.messageLabel.text
        }
        set {
            self.messageLabel.text = newValue
        }
        
    }
}

//
//  EmptyTableViewCell.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 05/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class EmptyTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
    }
}

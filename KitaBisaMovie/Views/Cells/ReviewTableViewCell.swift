//
//  ReviewTableViewCell.swift
//  KitaBisaMovie
//
//  Created by Twiscode on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class ReviewTableViewCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Variables
    var review: Review! {
        didSet {
            guard let review = review else { return }
            
            titleLabel.text = review.author
            reviewLabel.text = review.content
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        indicatorView.setRoundedCorner(cornerRadius: 2.0)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = ""
        reviewLabel.text = ""
    }
}

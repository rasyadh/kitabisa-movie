//
//  MovieCardTableViewCell.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

class MovieCardTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cardView: UIView!
    @IBOutlet weak var imageContent: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // MARK: - Variables
    var movie: Movie! {
        didSet {
            guard let movie = movie else { return }
            
            Apify.shared.getImage(movie.posterPath, for: imageContent)
            titleLabel.text = movie.title
            dateLabel.text = movie.releaseDate.toString(format: "dd MMMM yyyy")
            descriptionLabel.text = movie.overview
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
        
        imageContent.setRoundedCorner(cornerRadius: 2.0)
        cardView.setCardView(
            cornerRadius: 4,
            shadowSizeOffset: CGSize(width: 0, height: 1),
            shadowOpacity: 0.1,
            shadowColor: .black)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageContent.image = nil
        titleLabel.text = ""
        dateLabel.text = ""
        descriptionLabel.text = ""
    }
}

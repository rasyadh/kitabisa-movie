//
//  UITableView+Extension.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 05/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit

extension UITableView {
    func setEmptyView(title: String) {
        self.register(UINib(nibName: "EmptyTableViewCell", bundle: nil), forCellReuseIdentifier: "emptyCell")
        
        let cell = self.dequeueReusableCell(withIdentifier: "emptyCell") as! EmptyTableViewCell
        
        cell.titleLabel.text = title
        self.backgroundView = cell.contentView
        self.separatorStyle = .none
    }
    
    func restore(style: UITableViewCell.SeparatorStyle) {
        self.backgroundView = nil
        self.separatorStyle = style
    }
}

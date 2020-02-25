//
//  ImageTableViewCell.swift
//  SimpleFlickrImageLoader
//
//  Created by Ivan Chernetskiy on 25.02.2020.
//  Copyright © 2020 Ivan Chernetskiy. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var imageModel: ImageModel? {
        didSet {
            guard let contactItem = imageModel else { return }
            
            pictureImageView.image = contactItem.image
            nameLabel.text = contactItem.name
            
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let pictureImageView:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill // image will never be strecthed vertially or horizontally
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.layer.cornerRadius = 5
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(pictureImageView)
        containerView.addSubview(nameLabel)
        self.contentView.addSubview(containerView)
        
        pictureImageView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        pictureImageView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:10).isActive = true
        pictureImageView.widthAnchor.constraint(equalToConstant:100).isActive = true
        pictureImageView.heightAnchor.constraint(equalToConstant:100).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.pictureImageView.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:30).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo:self.containerView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.containerView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
}


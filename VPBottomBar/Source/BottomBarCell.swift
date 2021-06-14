//
//  BottomBarCell.swift
//  VPBottomBar
//
//  Created by Vicky Prajapati on 11/06/21.
//

import UIKit

class BottomBarCell: UICollectionViewCell {
    
    var objBottomNavItem: BottomNavItem? {
        didSet {
            guard let objBottomNavItem = objBottomNavItem else { return }
            imgIcon.image = UIImage.init(named: objBottomNavItem.imageName)
            lblTitle.text = objBottomNavItem.imageTitle
        }
    }
    
    // Setup UI
    fileprivate let contentStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .fillProportionally
        stackView.axis = .vertical
        return stackView
    }()
    
    fileprivate let imgIcon: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    
    fileprivate let lblTitle: UILabel = {
        let il = UILabel()
        il.font = UIFont.systemFont(ofSize: 12)
        il.textAlignment = .center
        return il
    }()
    
    // Initialization
    override init(frame: CGRect) {
        super.init(frame: .zero)
    
        contentStackView.addArrangedSubview(imgIcon)
        contentStackView.addArrangedSubview(lblTitle)
        contentView.addSubview(contentStackView)
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupConstraints() {
        //imgIcon
        let horizontalConstraint = NSLayoutConstraint(item: contentStackView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        let verticalConstraint = NSLayoutConstraint(item: contentStackView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: contentStackView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
        let widthConstraint = NSLayoutConstraint(item: contentStackView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: 40)
        self.addConstraints([horizontalConstraint, verticalConstraint, heightConstraint, widthConstraint])
    }
}

//
//  PortfolioView.swift
//  vestio
//
//  Created by Ben Lischin on 6/12/23.
//

import UIKit

class PortfolioView: UIView {

    var label: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .gray
        setupLabel()
        initConstraints()
    }
    
    func setupLabel() {
            label = UILabel()
            label.text = "HELPPPP"
            label.font = UIFont.systemFont(ofSize: 22)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            self.addSubview(label)
    }
    
    func initConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: self.safeAreaLayoutGuide.centerYAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

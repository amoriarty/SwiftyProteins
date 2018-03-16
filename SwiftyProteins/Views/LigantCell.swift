//
//  LigantCell.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT

final class LigantCell: GenericTableViewCell<String> {
    override var item: String? {
        didSet { textLabel?.text = item }
    }
    
    // MARK:- Views
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.hidesWhenStopped = true
        indicator.color = .black
        return indicator
    }()
    
    // MARK:- Setups
    override func setupViews() {
        super.setupViews()
        addSubview(indicator)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        _ = indicator.center(.verticaly, self)
        _ = indicator.constraint(.trailing, to: self, constant: 10)
    }
    
    // MARK:- Indicator accessor
    func startAnimating() {
        indicator.startAnimating()
    }
    
    func stopAnimating() {
        indicator.stopAnimating()
    }
}

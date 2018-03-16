//
//  ProteinController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT

final class ProteinController: GenericViewController {
    var ligand: Ligand? {
        didSet {
            guard let ligand = ligand else { return }
            title = ligand.name
        }
    }
    
    // MARK:- Setups
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
    }
}

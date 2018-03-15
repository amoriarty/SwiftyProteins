//
//  LigantCell.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT

class LigantCell: GenericTableViewCell<String> {
    override var item: String? {
        didSet { textLabel?.text = item }
    }
}

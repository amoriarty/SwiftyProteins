//
//  SCNGeometry.swift
//  SwiftyProteins
//
//  Created by Alexandre Legent on 20/03/2018.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation
import SceneKit

extension SCNGeometry {
    /* Shortcut for setting color */
    var color: UIColor? {
        set { firstMaterial?.diffuse.contents = newValue }
        get { return firstMaterial?.diffuse.contents as? UIColor }
    }
}

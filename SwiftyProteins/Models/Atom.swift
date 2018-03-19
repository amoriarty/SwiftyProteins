//
//  Atom.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/16/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation
import SceneKit

enum AtomType: String {
    case AS, B, BR, C, CA, CL, CO, CR, F, FE, H, I, MG, MN, MO, N, O, P, PT, RH, RU, S, SE, V, W
    case Other = "0"
}

struct Atom {
    let type: AtomType
    let position: SCNVector3
}

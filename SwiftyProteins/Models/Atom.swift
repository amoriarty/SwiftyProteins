//
//  Atom.swift
//  
//
//  Created by Alexandre LEGENT on 3/16/18.
//

import Foundation

enum AtomType: String {
    case C, O, S, N, H, F
}

struct Atom {
    let type: AtomType
    let cooridate: Coordinate
}

//
//  LigandsService.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation

class LigandsService {
    static let shared = LigandsService()
    let ligands: [String]
    
    init() {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        ligands = text.components(separatedBy: "\n").filter { $0 != "" }
    }
}

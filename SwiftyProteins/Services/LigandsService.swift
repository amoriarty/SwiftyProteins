//
//  LigandsService.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation

final class LigandsService {
    static let shared = LigandsService()
    let ligands: [String]
    
    init() {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        ligands = text.components(separatedBy: "\n").filter { $0 != "" }
    }
    
    func getSDF(for ligand: String, completion: @escaping () -> Void) {
        guard let url = URL(string: "https://files.rcsb.org/ligands/view/\(ligand)_model.sdf") else {
            completion()
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async { completion() }
                return
            }
            
            guard let data = data else {
                DispatchQueue.main.async { completion() }
                return
            }
            
            // DEBUG
            let string = String(data: data, encoding: .utf8)
            print(string as Any)
            // END DEBUG
            
            DispatchQueue.main.async { completion() }
            
        }.resume()
    }
}

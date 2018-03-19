//
//  LigandsService.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import Foundation
import SceneKit

final class LigandsService {
    static let shared = LigandsService()
    let ligands: [String]
    
    init() {
        guard let location = Bundle.main.path(forResource: "ligands", ofType: "txt") else { fatalError() }
        guard let text = try? String(contentsOf: URL(fileURLWithPath: location)) else { fatalError() }
        ligands = text.components(separatedBy: "\n").filter { $0 != "" }
    }
    
    func getSDF(for ligand: String, completion: @escaping (Ligand?) -> Void) {
        guard let url = URL(string: "https://files.rcsb.org/ligands/view/\(ligand)_model.sdf") else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { [unowned self] data, _, error in
            guard error == nil, let data = data, let file = String(data: data, encoding: .utf8) else {
                DispatchQueue.main.async { completion(nil) }
                return
            }
            
            let ligand = self.parseSDF(file)
            DispatchQueue.main.async { completion(ligand) }
            
        }.resume()
    }
    
    private func parseSDF(_ file: String) -> Ligand? {
        /* Spliting file by lines */
        let lines = file.components(separatedBy: "\n")
        
        /* Getting the line descriptor and spliting it by space */
        let descriptor = lines[3].components(separatedBy: " ").filter { $0 != "" }
        
        /* Getting ending atom line */
        guard let atomIndex = Int(descriptor[1]), atomIndex >= 4 else { return nil }
        
        /* Convert atoms lines into Atom */
        let atoms = lines[4...atomIndex].flatMap { line -> Atom? in
            /* Splitting atom line */
            let atom = line.components(separatedBy: " ").filter { $0 != "" }
            
            /* Creating non nil variable */
            guard let type = AtomType(rawValue: atom[3]) else { return nil }
            guard let x = Double(atom[0]) else { return nil }
            guard let y = Double(atom[1]) else { return nil }
            guard let z = Double(atom[2]) else { return nil }
            let coordinate = SCNVector3(x, y, z)
            
            return Atom(type: type, position: coordinate)
        }
        
        /* Convert links into Link */
        let links = lines[atomIndex + 1 ... lines.count - 4].flatMap { line -> Link? in
            /* Splitting link line */
            let link = line.components(separatedBy: " ").filter { $0 != "" }
            
            /* Creating non nil variable, and check that atoms identifier aren't out of bounds. */
            guard let left = Int(link[0]) else { return nil }
            guard let right = Int(link[1]) else { return nil }
            guard let number = Int(link[2]) else { return nil }
            guard left < atoms.count, right < atoms.count else { return nil }
            
            return Link(left: left, right: right, number: number)
        }
        
        return Ligand(name: lines[0], atoms: atoms, links: links)
    }
}

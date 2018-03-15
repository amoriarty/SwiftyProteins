//
//  LigandsController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT

class LigandsController: GenericTableViewController<LigantCell, String> {
    private let proteinController = ProteinController()
    override var items: [[String]]? {
        return [LigandsService.shared.ligands]
    }
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ligants"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        /* Present login controller */
        let controller = AuthenticationController()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    // MARK:- Setup
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
    }
    
    //MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let protein = items?[indexPath.section][indexPath.item]
        proteinController.title = protein
        navigationController?.pushViewController(proteinController, animated: true)
    }
}


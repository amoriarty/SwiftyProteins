//
//  LigandsController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT

final class LigandsController: GenericTableViewController<LigantCell, String>, UISearchResultsUpdating {
    private let proteinController = ProteinController()
    private var presentedLigants = LigandsService.shared.ligands
    override var items: [[String]]? {
        return [presentedLigants]
    }
    
    // MARK:- View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Ligants"
        setupNavBar()
        
        /* Present login controller */
        let controller = AuthenticationController()
        navigationController?.present(controller, animated: true, completion: nil)
    }
    
    // MARK:- Setup
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
    }
    
    /* Setup navigation bar and integrate search bar controller */
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController?.searchResultsUpdater = self
        navigationItem.searchController?.dimsBackgroundDuringPresentation = false
    }
    
    // MARK:- Table View Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /* Starting cell indicator */
        guard let cell = tableView.cellForRow(at: indexPath) as? LigantCell else { return }
        cell.startAnimating()
        
        /* Getting correct ligand from internet */
        guard let protein = items?[indexPath.section][indexPath.item] else { return }
        LigandsService.shared.getSDF(for: protein) { [unowned self] ligand in
            guard let ligand = ligand else {
                // TODO: Create error alert
                return
            }
            
            /* Ligand correctly get, configuring and pushing protein controller */
            self.proteinController.ligand = ligand
            self.navigationItem.searchController?.isActive = false
            self.navigationController?.pushViewController(self.proteinController, animated: true)
            cell.stopAnimating()
        }
    }
    
    // MARK:- Search Results Updating Delegate
    // TODO: Don't be case sensitive.
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text, search != "" else {
            presentedLigants = LigandsService.shared.ligands
            tableView.reloadData()
            return
        }
        
        presentedLigants = LigandsService.shared.ligands.filter { $0.contains(search) }
        tableView.reloadData()
    }
}


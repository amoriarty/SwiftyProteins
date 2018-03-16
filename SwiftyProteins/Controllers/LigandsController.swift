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
    private var selectionLock = false
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
        /* Checking that a cell isn't already selected */
        guard selectionLock == false else { return }
        selectionLock = true
        
        /* Starting cell indicator */
        guard let cell = tableView.cellForRow(at: indexPath) as? LigantCell else { return }
        cell.startAnimating()
        
        /* Getting correct ligand from internet */
        guard let protein = items?[indexPath.section][indexPath.item] else { return }
        LigandsService.shared.getSDF(for: protein) { [unowned self] ligand in
            /* Unlocking selection */
            self.selectionLock = false
            
            /* Stoping cell animation */
            cell.stopAnimating()
            
            /* Deactivate search controller in order to push another one */
            self.navigationItem.searchController?.isActive = false
            
            /* Presenting alert if ligand loading failed. */
            guard let ligand = ligand else {
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { _ in
                    alert.dismiss(animated: true, completion: nil)
                })
                
                alert.title = "Loading ligand failed"
                alert.message = "An error occured while loading ligands from RCSB"
                alert.addAction(cancel)
                self.navigationController?.present(alert, animated: true, completion: nil)
                return
            }
            
            /* Ligand correctly get, configuring and pushing protein controller */
            self.proteinController.ligand = ligand
            self.navigationController?.pushViewController(self.proteinController, animated: true)
        }
    }
    
    // MARK:- Search Results Updating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        guard let search = searchController.searchBar.text?.uppercased(), search != "" else {
            presentedLigants = LigandsService.shared.ligands
            tableView.reloadData()
            return
        }
        
        presentedLigants = LigandsService.shared.ligands.filter { $0.contains(search) }
        tableView.reloadData()
    }
}


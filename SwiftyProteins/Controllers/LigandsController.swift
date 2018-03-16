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
        
        /* Preparing protein controller */
        let protein = items?[indexPath.section][indexPath.item]
        proteinController.title = protein
        navigationItem.searchController?.isActive = false
        
        // DEBUG WAIT
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) { [unowned self] _ in
            cell.stopAnimating()
            self.navigationController?.pushViewController(self.proteinController, animated: true)
        }
    }
    
    // MARK:- Search Results Updating Delegate
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


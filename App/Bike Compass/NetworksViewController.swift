//
//  NetworksViewController.swift
//  Bike Compass
//
//  Created by Raúl Riera on 26/04/2016.
//  Copyright © 2016 Raul Riera. All rights reserved.
//

import UIKit
import CityBikesKit

protocol NetworksViewControllerDelegate: class {
    func networksViewController(viewController: NetworksViewController, didSelectedNetwork network: Network, atIndexPath indexPath: NSIndexPath)
}

class NetworksViewController: UITableViewController {
    
    weak var delegate: NetworksViewControllerDelegate?
    var selectedNetwork: Network?
    var networks: [(String, [Network])] = [] {
        didSet {
            tableView.reloadData()
            
            guard let selectedNetwork = selectedNetwork,
                sectionIndex = networks.indexOf({ selectedNetwork.location.country == $0.0 }),
                rowIndex = networks[sectionIndex].1.indexOf({ $0.id == selectedNetwork.id }) else { return }
            
            tableView.selectRowAtIndexPath(NSIndexPath(forItem: rowIndex, inSection: sectionIndex), animated: false, scrollPosition: .Bottom)            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadNetworks()
    }
    
    // MARK: CityBikesKit
    
    private func loadNetworks() {
        CityBikes.networks { response in
            switch response {
            case .Success(let networks):
                let grouped = networks.sortByCity().categorise { $0.location.country }
                self.networks = grouped.sort { $0.0 < $1.0 }
            case .Failure(let error):
                print(error)
            }
        }
    }
    
}

extension NetworksViewController {
       
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return networks.count
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks[section].1.count
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return networks[section].0
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        let network = networks[indexPath.section].1[indexPath.row]
        
        cell.textLabel?.text = network.location.city
        cell.detailTextLabel?.text = network.name
        
        guard let selectedNetwork = selectedNetwork else { return }
        cell.selected = network == selectedNetwork
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCellWithIdentifier("NetworkTableViewCell")!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let network = networks[indexPath.section].1[indexPath.row]
        delegate?.networksViewController(self, didSelectedNetwork: network, atIndexPath: indexPath)
    }
    
}
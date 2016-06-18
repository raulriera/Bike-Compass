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
    func networksViewController(_ viewController: NetworksViewController, didSelectedNetwork network: Network, atIndexPath indexPath: IndexPath)
}

class NetworksViewController: UITableViewController {
    
    weak var delegate: NetworksViewControllerDelegate?
    var selectedNetwork: Network?
    var networks: [(key: String, value: [Network])] = [] {
        didSet {
            tableView.reloadData()
            
            guard let selectedNetwork = selectedNetwork,
                sectionIndex = networks.index(where: { selectedNetwork.location.country == $0.0 }),
                rowIndex = networks[sectionIndex].1.index(where: { $0.id == selectedNetwork.id }) else { return }
            
            tableView.selectRow(at: IndexPath(item: rowIndex, section: sectionIndex), animated: false, scrollPosition: .bottom)            
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
            case .success(let networks):
                let grouped = networks.sortByCity().categorise { $0.location.country }
                self.networks = grouped.sorted { $0.key < $1.key }
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

extension NetworksViewController {
       
    override func numberOfSections(in tableView: UITableView) -> Int {
        return networks.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return networks[section].1.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return networks[section].0
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let network = networks[(indexPath as NSIndexPath).section].1[(indexPath as NSIndexPath).row]
        
        cell.textLabel?.text = network.location.city
        cell.detailTextLabel?.text = network.name
        
        guard let selectedNetwork = selectedNetwork else { return }
        cell.isSelected = network == selectedNetwork
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return tableView.dequeueReusableCell(withIdentifier: "NetworkTableViewCell")!
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let network = networks[(indexPath as NSIndexPath).section].1[(indexPath as NSIndexPath).row]
        delegate?.networksViewController(self, didSelectedNetwork: network, atIndexPath: indexPath)
    }
    
}

//
//  FavouriteMoviesViewController.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 05/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

class FavouriteMoviesViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Outlet Instance
    var refreshControl = UIRefreshControl()
    
    // MARK: - Variables
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localify.get("favourite_movie.title")
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.register(
            UINib(nibName: "MovieCardTableViewCell", bundle: nil), forCellReuseIdentifier: "movieCardCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        SVProgressHUD.show()
        getFavouriteMovies()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMovie" {
            let viewController = segue.destination as? MovieViewController
            viewController?.movie = movies[(tableView!.indexPathForSelectedRow!).row]
        }
    }

    // MARK: - Selector
    @objc private func refreshData(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
            getFavouriteMovies()
        }
    }
    
    // MARK: - Functions
    private func getFavouriteMovies() {
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
        movies = RealmHelper.shared.getFavouriteMovies(type: MovieRealm.self)
        SVProgressHUD.dismiss()
    }
}

// MARK: - UITableViewDataSource
extension FavouriteMoviesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMovieCard(tableView, indexPath)
    }
    
    func createMovieCard(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "movieCardCell", for: indexPath)
            as! MovieCardTableViewCell
        
        cell.movie = movies[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension FavouriteMoviesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showMovie", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

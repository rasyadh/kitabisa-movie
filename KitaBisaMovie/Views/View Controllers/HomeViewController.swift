//
//  HomeViewController.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var categoryButton: UIButton!
    
    // MARK: - Outlet Instance
    var refreshControl = UIRefreshControl()
    
    var movies = [Movie]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = Localify.get("app.name")
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(named: "ic_heart")?.withRenderingMode(.alwaysOriginal),
            style: .plain,
            target: self,
            action: #selector(favouriteMovies(_:)))
        
        refreshControl.addTarget(self, action: #selector(refreshData(_:)), for: .valueChanged)
        tableView.addSubview(refreshControl)
        tableView.register(
            UINib(nibName: "MovieCardTableViewCell", bundle: nil), forCellReuseIdentifier: "movieCardCell")
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Notify.shared.listen(
            self,
            selector: #selector(moviesReceived(_:)),
            name: NotifName.getMovies,
            object: nil)
        getMoviesByCategory(category: Storify.shared.currentCategory ,page: 1)
        SVProgressHUD.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        Notify.shared.removeListener(self)
    }
    
    // MARK: - Notification Handler
    @objc func moviesReceived(_ notification: Notification) {
        SVProgressHUD.dismiss()
        if refreshControl.isRefreshing { refreshControl.endRefreshing() }
        if notification.userInfo!["success"] as! Bool {
            movies = Storify.shared.movies
        } else {
            Alertify.showErrorMessage(sender: self, manager: managerViewController, notification: notification)
        }
    }
    
    // MARK: - Selector
    @objc func favouriteMovies(_ barButtonItem: UIBarButtonItem) {
        print("Favourite Movies")
    }
    
    @objc private func refreshData(_ sender: UIRefreshControl) {
        if sender.isRefreshing {
            getMoviesByCategory(category: Storify.shared.currentCategory, page: 1)
        }
    }
    
    // MARK: - IBActions
    @IBAction func categoryTouchUpInside(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: Localify.get("category.action.popular"), style: .default, handler: { alert in
            self.movies.removeAll()
            self.getMoviesByCategory(category: .popular, page: 1)
            SVProgressHUD.show()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("category.action.upcoming"), style: .default, handler: { alert in
            self.movies.removeAll()
            self.getMoviesByCategory(category: .upcoming, page: 1)
            SVProgressHUD.show()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("category.action.top_rated"), style: .default, handler: { alert in
            self.movies.removeAll()
            self.getMoviesByCategory(category: .topRated, page: 1)
            SVProgressHUD.show()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("category.action.now_playing"), style: .default, handler: { alert in
            self.movies.removeAll()
            self.getMoviesByCategory(category: .nowPlaying, page: 1)
            SVProgressHUD.show()
        }))
        actionSheet.addAction(UIAlertAction(title: Localify.get("category.action.cancel"), style: .cancel, handler: nil))
        present(actionSheet, animated: true, completion: nil)
    }
    
    // MARK: - Functions
    private func subviewSettings() {
        categoryButton.setTitle(Localify.get("home.button.category"), for: .normal)
    }
    
    private func getMoviesByCategory(category: CategorySortMovie, page: Int) {
        Storify.shared.currentCategory = category
        switch category {
        case .popular:
            Apify.shared.getPopularMovies(page: page)
        case .upcoming:
            Apify.shared.getUpcomingMoviews(page: page)
        case .nowPlaying:
            Apify.shared.getNowPlayingMovies(page: page)
        case .topRated:
            Apify.shared.getTopRatedMovies(page: page)
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return createMovieCard(tableView, cellForRowAt: indexPath)
    }
    
    func createMovieCard(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "movieCardCell", for: indexPath)
            as! MovieCardTableViewCell
        
        cell.movie = movies[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !movies.isEmpty && indexPath.row == movies.count - 1 {
            guard let page = Storify.shared.page["movies"] else { return }
            if page["page"].intValue < page["total_pages"].intValue {
                let nextPage = page["page"].intValue + 1
                getMoviesByCategory(category: Storify.shared.currentCategory, page: nextPage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

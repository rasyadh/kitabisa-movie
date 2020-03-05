//
//  MovieViewController.swift
//  KitaBisaMovie
//
//  Created by Rasyadh Abdul Aziz on 04/03/20.
//  Copyright © 2020 rasyadh. All rights reserved.
//

import UIKit
import SVProgressHUD

class MovieViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Variables
    var movie: Movie!
    var reviews = [Review]() {
        didSet {
            tableView.reloadData()
        }
    }
    var isFavourite = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = movie.title
        
        tableView.register(
            UINib(nibName: "MovieInfoTableViewCell", bundle: nil), forCellReuseIdentifier: "movieInfoCell")
        tableView.register(
            UINib(nibName: "ReviewHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewHeaderCell")
        tableView.register(
            UINib(nibName: "ReviewTableViewCell", bundle: nil), forCellReuseIdentifier: "reviewCell")
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        isFavourite = RealmHelper.shared.checkIsFavourite(type: MovieRealm.self, id: movie.id)
        setFavouriteButtonItem(isFavourite)
        
        Notify.shared.listen(
            self,
            selector: #selector(movieReceived(_:)),
            name: NotifName.getMovieDetail,
            object: nil)
        Notify.shared.listen(
            self,
            selector: #selector(reviewsReceived(_:)),
            name: NotifName.getMovieReviews,
            object: nil)
        Apify.shared.getMovieDetail(id: movie.id)
        Apify.shared.getMovieReviews(id: movie.id)
        SVProgressHUD.show()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        SVProgressHUD.dismiss()
        Notify.shared.removeListener(self)
    }
    
    // MARK: - Notification Handler
    @objc func movieReceived(_ notification: Notification) {
        SVProgressHUD.dismiss()
        if notification.userInfo!["success"] as! Bool {
            movie = Storify.shared.movie
            tableView.reloadSections(IndexSet(arrayLiteral: 0), with: .automatic)
        } else {
            Alertify.showErrorMessage(sender: self, manager: managerViewController, notification: notification)
        }
    }
    
    @objc func reviewsReceived(_ notification: Notification) {
        SVProgressHUD.dismiss()
        if notification.userInfo!["success"] as! Bool {
            reviews = Storify.shared.reviews
        } else {
            Alertify.showErrorMessage(sender: self, manager: managerViewController, notification: notification)
        }
    }
    
    // MARK: - Selector
    @objc func toggleFavourite(_ barBUttonItem: UIBarButtonItem) {
        isFavourite = RealmHelper.shared.addToFavourite(type: MovieRealm.self, movie: movie)
        setFavouriteButtonItem(isFavourite)
    }
    
    // MARK: - Functions
    private func setFavouriteButtonItem(_ favourite: Bool) {
        if favourite {
            let favouriteItem = UIBarButtonItem(
                image: UIImage(named: "ic_heart")?.withRenderingMode(.alwaysTemplate),
                style: .plain,
                target: self,
                action: #selector(toggleFavourite(_:)))
            favouriteItem.tintColor = UIColor.ntRed
            navigationItem.rightBarButtonItem = favouriteItem
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(
                image: UIImage(named: "ic_heart_outline")?.withRenderingMode(.alwaysOriginal),
                style: .plain,
                target: self,
                action: #selector(toggleFavourite(_:)))
        }
    }
    
    
}

// MARK: - UITableViewDataSource
extension MovieViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 || section == 1 {
            return 1
        } else {
            return reviews.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return createMovieDetail(tableView, indexPath)
        } else if indexPath.section == 1 {
            return createReviewHeader(tableView, indexPath)
        }
        return createReview(tableView, indexPath)
    }
    
    func createMovieDetail(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "movieInfoCell", for: indexPath)
            as! MovieInfoTableViewCell
        
        cell.movie = movie
        cell.selectionStyle = .none
        
        return cell
    }
    
    func createReviewHeader(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "reviewHeaderCell", for: indexPath)
            as! ReviewHeaderTableViewCell
        
        cell.selectionStyle = .none
        
        return cell
    }
    
    func createReview(_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "reviewCell", for: indexPath)
            as! ReviewTableViewCell
        
        cell.review = reviews[indexPath.row]
        cell.selectionStyle = .none
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension MovieViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if !reviews.isEmpty && indexPath.row == reviews.count - 1 {
            guard let page = Storify.shared.page["reviews"] else { return }
            if page["page"].intValue < page["total_pages"].intValue {
                let nextPage = page["page"].intValue + 1
                Apify.shared.getMovieReviews(id: movie.id, page: nextPage)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            if let url = URL(string: reviews[indexPath.row].url) {
                UIApplication.shared.open(url)
            }
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

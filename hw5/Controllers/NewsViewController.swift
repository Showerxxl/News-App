
import UIKit

class NewsViewController: UIViewController, NewsDisplayLogic {
    var interactor: (NewsBusinessLogic & NewsDataStore)?

    private let tableView = UITableView()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "ПОСЛЕДНИЕ НОВОСТИ"
        label.font = UIFont.systemFont(ofSize: Constants.titleFontSize)
        label.textColor = .black
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupTitleLabel()
        setupTableView()
        setupVIP()
        interactor?.loadFreshNews()

        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshNews), for: .valueChanged)
        refreshControl.tintColor = .black
    }

    private func setupTitleLabel() {
        view.addSubview(titleLabel)
        titleLabel.pinCenterX(to: view)
        titleLabel.pinTop(to: view.safeAreaLayoutGuide.topAnchor, Constants.titleTopMargin)
    }

    private func setupTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ArticleCell.self, forCellReuseIdentifier: "ArticleCell")
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = Constants.estimatedRowHeight


        tableView.pinTop(to: titleLabel, Constants.tableViewTopMargin)
        tableView.pinLeft(to: view)
        tableView.pinRight(to: view)
        tableView.pinBottom(to: view)
    }

    private func setupVIP() {
        let viewController = self
        let interactor = NewsInteractor()
        let presenter = NewsPresenter()

        viewController.interactor = interactor
        interactor.presenter = presenter
        presenter.viewController = viewController
    }

    @objc private func refreshNews() {
        refreshControl.beginRefreshing()
        interactor?.loadFreshNews()
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.refreshDelay) {
            self.refreshControl.endRefreshing()
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return interactor?.articles.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleCell", for: indexPath) as! ArticleCell
        if let article = interactor?.articles[indexPath.row] {
            cell.configure(with: article)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Get the tapped cell and apply shimmer 
        guard let cell = tableView.cellForRow(at: indexPath) as? ArticleCell else {
            pushWebViewController(for: indexPath)
            return
        }
        
        Shimmer.start(for: cell)
        
        // Stop shimmer after a short delay and push WebViewController
        DispatchQueue.main.asyncAfter(deadline: .now() + Constants.time) { [weak self] in
            Shimmer.stop(for: cell)
            self?.pushWebViewController(for: indexPath)
        }
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = scrollView.contentSize.height
        let contentOffsetY = scrollView.contentOffset.y
        let scrollViewHeight = scrollView.frame.size.height

        if contentOffsetY + scrollViewHeight >= contentHeight - Constants.scrollThreshold {
            interactor?.loadMoreNews()
        }
    }
}


extension NewsViewController {
    private func pushWebViewController(for indexPath: IndexPath) {
        if let article = interactor?.articles[indexPath.row], let articleUrl = article.ArticleUrl {
            let webViewController = WebViewController()
            webViewController.url = articleUrl
            navigationController?.pushViewController(webViewController, animated: true)
        } else {
            print("Нет URL для этой новости.")
        }
    }
}

extension NewsViewController {
    func displayNews(viewModel: NewsModels.FetchNews.ViewModel) {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

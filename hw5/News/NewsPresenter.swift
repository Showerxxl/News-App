
// MARK: - NewsDisplayLogic
protocol NewsDisplayLogic: AnyObject {
    func displayNews(viewModel: NewsModels.FetchNews.ViewModel)
}
// MARK: - NewsPresentationLogic
protocol NewsPresentationLogic {
    func presentNews(articles: [ArticleModel])
}

class NewsPresenter: NewsPresentationLogic {
    weak var viewController: NewsDisplayLogic?

    func presentNews(articles: [ArticleModel]) {
        let viewModel = NewsModels.FetchNews.ViewModel(articles: articles)
        viewController?.displayNews(viewModel: viewModel)
    }
}


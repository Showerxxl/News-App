import UIKit


class ArticleCell: UITableViewCell {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: Article.titleFontSize)
        label.textColor = Article.titleTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    private let articleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = Article.imageCornerRadius
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: Article.descriptionFontSize)
        label.textColor = Article.descriptionTextColor
        label.textAlignment = .center
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    // StackView for arranging UI elements (title, image, description)
    private let contentStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Article.spacing
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()

    // Identifier for the current image request URL
    private var currentImageRequestURL: URL?

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // Prepare the cell for reuse
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        descriptionLabel.text = nil
        articleImageView.image = nil
        currentImageRequestURL = nil
    }

    // MARK: - Setup UI
    private func setupUI() {
        contentView.backgroundColor = Article.contentViewBackgroundColor
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(articleImageView)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.pinTop(to: contentView, Double(Article.padding))
        contentStackView.pinLeft(to: contentView, Double(Article.padding))
        contentStackView.pinRight(to: contentView, Double(Article.padding))
        contentStackView.pinBottom(to: contentView, Double(Article.padding))
        articleImageView.heightAnchor.constraint(equalTo: articleImageView.widthAnchor, multiplier: Article.imageAspectRatio).isActive = true
    }

    // MARK: - Configure cell with data
    func configure(with article: ArticleModel) {
        titleLabel.text = article.title
        descriptionLabel.text = article.announce

        if let imageUrl = article.img?.url {
            currentImageRequestURL = imageUrl
            loadImage(from: imageUrl) { [weak self] image in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    if self.currentImageRequestURL == imageUrl {
                        self.articleImageView.image = image
                    }
                }
            }
        } else {
            articleImageView.image = nil
        }
    }

    // MARK: - Asynchronous image loading with completion
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            completion(image)
        }
    }

    // Alternative loadImage method without a completion handler (kept for compatibility)
    func loadImage(from url: URL) {
        currentImageRequestURL = url
        DispatchQueue.global().async {
            guard let data = try? Data(contentsOf: url),
                  let image = UIImage(data: data) else { return }

            DispatchQueue.main.async {
                if self.currentImageRequestURL == url {
                    self.articleImageView.image = image
                }
            }
        }
    }
}

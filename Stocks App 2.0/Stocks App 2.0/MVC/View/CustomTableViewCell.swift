import UIKit

protocol CustomTableViewCellDelegate:  AnyObject {
    func starDidTapped(with cell: CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {
    static let identifier = "CustomTableViewCell"
    weak var delegate: CustomTableViewCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func layoutSubviews() {
        contentView.addSubview(companyImage)
        contentView.addSubview(companyName)
        contentView.addSubview(price)
        contentView.addSubview(ticker)
        contentView.addSubview(difference)
        contentView.addSubview(starButton)
        starButton.addTarget(self, action: #selector(starButtomPressed), for: .touchUpInside)
        activateLayout()
    }

    var companyImage: UIImageView = {
        let image = UIImageView()
        let imageForm = UIImage()
        image.contentMode = .scaleAspectFill
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 16
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .white
        return image
    }()
    
    var companyName: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var ticker: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var price: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-Bold", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var difference: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var starButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "star.fill")
        button.tintColor = UIColor(hexString: "#BABABA")
        button.setBackgroundImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    @objc func starButtomPressed(){
        changeStarColor()
        delegate?.starDidTapped(with: self)
    }
    
    private func changeStarColor(){
        if starButton.tintColor == UIColor(hexString: "#BABABA"){
            starButton.tintColor = UIColor(hexString: "#FFCA1C")
        }
        else{
            starButton.tintColor = UIColor(hexString: "#BABABA")
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = self.frame.height / 4.0
    }

    
    private func activateLayout(){
        NSLayoutConstraint.activate([
           companyImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
           companyImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
           companyImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
           companyImage.widthAnchor.constraint(equalTo: companyImage.heightAnchor),
            
           ticker.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
           ticker.leadingAnchor.constraint(equalTo: companyImage.trailingAnchor, constant: 12),
           ticker.heightAnchor.constraint(equalToConstant: 24),
           
           companyName.widthAnchor.constraint(equalToConstant: 160),
           companyName.topAnchor.constraint(equalTo: ticker.bottomAnchor),
           companyName.leadingAnchor.constraint(equalTo: companyImage.trailingAnchor, constant: 12),
           companyName.heightAnchor.constraint(equalToConstant: 16),
           
           price.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 14),
           price.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -17),
           price.heightAnchor.constraint(equalToConstant: 24),
           
           difference.topAnchor.constraint(equalTo: price.bottomAnchor),
           difference.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
           difference.heightAnchor.constraint(equalToConstant: 16),
           
           starButton.leadingAnchor.constraint(equalTo: ticker.trailingAnchor, constant: 6),
           starButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
           starButton.heightAnchor.constraint(equalToConstant: 20),
           starButton.widthAnchor.constraint(equalToConstant: 20),
        ])
    }

}

import UIKit

class LabelsCollectionViewCell: UICollectionViewCell {
    static let identifier = "LabelsCollectionViewCell"
    weak var txtLabel : UILabel!
    
    override init(frame: CGRect){
        super.init(frame: frame)
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
            ])
        
        txtLabel = label
        txtLabel.font = UIFont(name: "Montserrat-SemiBold", size: 14)
        txtLabel.textAlignment = .center
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

import UIKit

class Section: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.contentView.backgroundColor = .darkGray
//        self.textLabel.textColor = .systemGray5
        self.bringSubviewToFront(textLabel)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
    }
}


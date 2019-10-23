import UIKit

class Cell: UICollectionViewCell {
    
    @IBOutlet weak var textLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.bringSubviewToFront(textLabel)
        self.contentView.backgroundColor = .clear
        self.selectedBackgroundView = UIView()
        self.selectedBackgroundView?.backgroundColor = .systemBlue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.textLabel.text = nil
    }
}

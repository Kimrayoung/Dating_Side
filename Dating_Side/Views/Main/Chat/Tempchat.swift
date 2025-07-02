import SwiftUI
import UIKit

// SwiftUI에서 사용할 메인 뷰
struct Tempchat: View {
    var body: some View {
        NavigationView {
            TableViewControllerWrapper()
                .navigationTitle("Table View")
                .navigationBarTitleDisplayMode(.large)
        }
    }
}

// UIViewControllerRepresentable 래퍼
struct TableViewControllerWrapper: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> ViewController {
        // 직접 ViewController 인스턴스 생성
        let viewController = ViewController()
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // 필요한 경우 업데이트 로직 추가
    }
}

// 기존 UIKit ViewController (원래 로직 유지)
class ViewController: UIViewController {
    
    var tableView: UITableView!
    var headersIndex = [IndexPath]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTableView()
        registerCells()
    }
    
    private func setupTableView() {
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func registerCells() {
        // 프로그래매틱으로 셀 등록 (XIB 파일 대신 코드로 생성)
        tableView.register(MessageTableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(HeaderTableViewCell.self, forCellReuseIdentifier: "HeaderTableViewCell")
    }
}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 5 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderTableViewCell", for: indexPath) as! HeaderTableViewCell
            cell.centerLabel.text = "sanjay"
            cell.centerLabel.center.x = view.center.x
            if !headersIndex.contains(indexPath) {
                headersIndex.append(indexPath)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MessageTableViewCell
            cell.leftLabel.text = "Message \(indexPath.row)"
            cell.rightLabel.text = indexPath.row.description
            return cell
        }
    }
    
    // 원래 코드의 핵심 기능: 스크롤 시 헤더 라벨이 화면 중앙에 고정
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for i in headersIndex {
            if let cell = tableView.cellForRow(at: i) {
                if tableView.visibleCells.contains(cell) {
                    let header = cell as! HeaderTableViewCell
                    // 수직 스크롤 오프셋에 따라 헤더 라벨을 화면 중앙에 고정
                    header.centerLabel.center.x = view.center.x + scrollView.contentOffset.x
                }
            }
        }
    }
}

// 메시지 셀 클래스 (XIB 대신 코드로 생성)
class MessageTableViewCell: UITableViewCell {
    let leftLabel = UILabel()
    let rightLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        leftLabel.translatesAutoresizingMaskIntoConstraints = false
        rightLabel.translatesAutoresizingMaskIntoConstraints = false
        
        leftLabel.font = UIFont.systemFont(ofSize: 16)
        rightLabel.font = UIFont.systemFont(ofSize: 14)
        rightLabel.textColor = .gray
        
        contentView.addSubview(leftLabel)
        contentView.addSubview(rightLabel)
        
        NSLayoutConstraint.activate([
            leftLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            leftLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            rightLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            rightLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            contentView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 셀 구분선 추가
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        leftLabel.text = nil
        rightLabel.text = nil
    }
}

// 헤더 셀 클래스 (XIB 대신 코드로 생성)
class HeaderTableViewCell: UITableViewCell {
    let centerLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    private func setupViews() {
        centerLabel.translatesAutoresizingMaskIntoConstraints = false
        centerLabel.font = UIFont.boldSystemFont(ofSize: 16)
        centerLabel.textAlignment = .center
        centerLabel.textColor = .black
        
        contentView.addSubview(centerLabel)
        
        NSLayoutConstraint.activate([
            centerLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            centerLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            contentView.heightAnchor.constraint(equalToConstant: 44)
        ])
        
        // 셀 구분선 추가
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.separator
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(separatorView)
        
        NSLayoutConstraint.activate([
            separatorView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            separatorView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            separatorView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        centerLabel.text = nil
    }
}

// SwiftUI 프리뷰
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Tempchat()
    }
}

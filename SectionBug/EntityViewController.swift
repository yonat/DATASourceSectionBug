//
//  EntityViewController.swift
//  List all NSManagedObject-s of an entity. Subclasses should override refresh().
//
//  Created by Yonat Sharon on 17.01.2018.
//  Copyright © 2018 Yonat Sharon. All rights reserved.
//

import DATASource
import SweeterSwift
import UIKit

open class EntityViewController: UITableViewController, DATASourceDelegate {
    /// action to take when a row is selected
    public typealias SelectAction = (NSManagedObject) -> Void
    public var selectAction: SelectAction?

    /// accessoryView to show for each row
    public typealias AccessorySource = (NSManagedObject) -> UIView?
    public var accessorySource: AccessorySource?

    let managedObjectContext: NSManagedObjectContext
    let entityName: String?
    let predicate: NSPredicate?
    let titleEmptyText: String?
    let titleAttribute: String?
    let detailAttribute: String?
    let sortAttribute: String?
    let sortAscending: Bool
    let sectionAttribute: String?

    public lazy var dataSource: DATASource = {
        let request: NSFetchRequest<NSFetchRequestResult>
        if let entityName = entityName {
            request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            request.predicate = predicate
            request.sortDescriptors = [
                sectionAttribute?.sortDescriptor(),
                sortAttribute?.sortDescriptor(ascending: sortAscending),
                titleAttribute?.sortDescriptor(selector: #selector(NSString.localizedStandardCompare(_:))),
            ].compact
        } else {
            request = NSFetchRequest()
        }

        let dataSource = DATASource(
            tableView: tableView,
            cellIdentifier: "Cell",
            fetchRequest: request,
            mainContext: managedObjectContext,
            sectionName: sectionAttribute
        )

        dataSource.delegate = self
        return dataSource
    }()

    // MARK: - Initialization

    public init(
        managedObjectContext: NSManagedObjectContext,
        entity: String,
        predicate: NSPredicate? = nil,
        titleEmptyText: String? = nil,
        titleAttribute: String? = nil,
        detailAttribute: String? = nil,
        sortAttribute: String? = nil,
        sortAscending: Bool = true,
        sectionAttribute: String? = nil,
        style: UITableView.Style = .plain
    ) {
        self.managedObjectContext = managedObjectContext
        entityName = entity
        self.predicate = predicate
        self.titleEmptyText = titleEmptyText
        self.titleAttribute = titleAttribute
        self.detailAttribute = detailAttribute
        self.sortAttribute = sortAttribute
        self.sortAscending = sortAscending
        self.sectionAttribute = sectionAttribute
        super.init(style: style)
    }

    public required init?(coder: NSCoder) {
        fatalError("init?(coder:) not implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(SubtitleTableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.dataSource = dataSource
        dataSource.delegate = self
    }

    // MARK: - UITableViewDelegate & DataSource

    @objc open func dataSource(_ dataSource: DATASource, configureTableViewCell cell: UITableViewCell, withItem item: NSManagedObject, atIndexPath indexPath: IndexPath) {
        if let titleAttribute = titleAttribute {
            cell.textLabel?.text = "\(item.value(forKey: titleAttribute) ?? titleEmptyText ?? "")"
        }
        if let detailAttribute = detailAttribute {
            let detailValue = item.value(forKey: detailAttribute) ?? ""
            cell.detailTextLabel?.text = "\(detailValue)"
        } else {
            cell.textLabel?.numberOfLines = 0
        }
        if let accessorySource = accessorySource {
            cell.accessoryView = accessorySource(item)
        } else {
            cell.accessoryType = nil != selectAction ? .disclosureIndicator : .none
        }
    }

    open override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedObject = dataSource.object(indexPath) else { return }
        selectAction?(selectedObject)
    }
}

// MARK: - Helpers

class SubtitleTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension String {
    func sortDescriptor(ascending: Bool = true, selector: Selector? = nil) -> NSSortDescriptor {
        NSSortDescriptor(key: self, ascending: ascending, selector: selector)
    }
}

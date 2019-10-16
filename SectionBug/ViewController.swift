//
//  ViewController.swift
//  SectionBug
//
//  Created by Yonat Sharon on 16/10/2019.
//  Copyright © 2019 Yonat Sharon. All rights reserved.
//

import UIKit

class ViewController: EntityViewController {

    init() {
        super.init(
            managedObjectContext: (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext,
            entity: "Session",
            titleAttribute: "text",
            sectionAttribute: "phase"
        )
    }

    public required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sessions"
        view.backgroundColor = .systemBackground
    }
}


//
//  CurveExerciseUnitTests.swift
//  CurveExerciseUnitTests
//

import XCTest
import Foundation
import UIKit

@testable import CurveExercise

class CurveExerciseUnitTests: XCTestCase {
    
    var vc: MovieViewController?

    override func setUp() {
        super.setUp()

        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        vc = (storyboard.instantiateViewController(withIdentifier: "MovieViewController") as? MovieViewController)!
        _ = vc!.view
    }

    func testInitMyTableView() {
        XCTAssertTrue(vc!.movieTableView.isHidden)
    }
    
    func testTableDataSource() {
        XCTAssertTrue(vc!.movieTableView.dataSource is MovieViewController)
    }
    
    func testTableDelegate() {
        XCTAssertTrue(vc!.movieTableView.delegate is MovieViewController)
    }
}

//
//  ProteinController.swift
//  SwiftyProteins
//
//  Created by Alexandre LEGENT on 3/15/18.
//  Copyright © 2018 Alexandre LEGENT. All rights reserved.
//

import UIKit
import ToolboxLGNT
import SceneKit

final class ProteinController: GenericViewController {
    var ligand: Ligand? {
        didSet {
            guard let ligand = ligand else { return }
            title = ligand.name
        }
    }
    
    private let scene: SCNScene = {
        let camera = SCNNode()
        let scene = SCNScene()
        camera.camera = SCNCamera()
        camera.position = SCNVector3(0, 0, 10)
        scene.rootNode.addChildNode(camera)
        return scene
    }()
    
    private lazy var sceneView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
        
        // TODO: Remove unused parameters
        view.showsStatistics = true
        // view.autoenablesDefaultLighting = true
        
        return view
    }()
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Remove debug form
        // DEBUG
        let box = SCNBox()
        let node = SCNNode(geometry: box)
        node.position = SCNVector3(0, 0, 0)
        box.firstMaterial?.diffuse.contents = UIColor.green
        scene.rootNode.addChildNode(node)
        // END DEBUG
    }
    
    // MARK:- Setups
    override func setupViews() {
        super.setupViews()
        view.backgroundColor = Colors.background
        view.addSubview(sceneView)
    }
    
    override func setupLayouts() {
        super.setupLayouts()
        _ = sceneView.fill(view.safeAreaLayoutGuide)
    }
}

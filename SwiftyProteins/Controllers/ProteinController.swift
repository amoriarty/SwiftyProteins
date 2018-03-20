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
    private var ligandNode: SCNNode?
    var ligand: Ligand? {
        didSet {
            guard let ligand = ligand else { return }
            title = ligand.name
            generateModel(with: ligand)
        }
    }
    
    private let camera: SCNNode = {
        let node = SCNNode()
        node.camera = SCNCamera()
        node.position = SCNVector3(0, 0, 20)
        return node
    }()
    
    private lazy var scene: SCNScene = {
        let scene = SCNScene()
        scene.rootNode.addChildNode(camera)
        return scene
    }()
    
    private lazy var sceneView: SCNView = {
        let view = SCNView()
        view.allowsCameraControl = true
        view.scene = scene
        return view
    }()
    
    // MARK:- View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavBar()
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
    
    private func setupNavBar() {
        let button = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(handleShare))
        navigationItem.rightBarButtonItem = button
    }
    
    // MARK:- Scene Logics
    private func generateModel(with ligand: Ligand) {
        /* Remove ligand node before rebuild it and re-add it to root node. */
        ligandNode?.removeFromParentNode()
        ligandNode = SCNNode()
        
        /* Generate new models */
        let nodes = generateModel(with: ligand.atoms)
        generateModel(with: ligand.links, for: nodes)
        
        /* Adding ligandNode to scene */
        scene.rootNode.addChildNode(ligandNode!)
    }
    
    private func generateModel(with atoms: [Atom]) -> [SCNNode] {
        /* Calculating offset vector to center ligand into scene */
        let offsetX = atoms.reduce(0) { $0 + $1.position.x } / Float(atoms.count)
        let offsetY = atoms.reduce(0) { $0 + $1.position.y } / Float(atoms.count)
        let offsetZ = atoms.reduce(0) { $0 + $1.position.z } / Float(atoms.count)
        let offsetVector = SCNVector3(offsetX, offsetY, offsetZ)
        var nodes = [SCNNode]()
        
        /* Adding all atoms into ligandNode */
        atoms.forEach { atom in
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            node.position = atom.position - offsetVector
            sphere.color = Colors.CPK[atom.type]
            ligandNode?.addChildNode(node)
            nodes.append(node)
        }
        
        return nodes
    }
    
    private func generateModel(with links: [Link], for nodes: [SCNNode]) {
        /* Adding all links between atoms */
        links.forEach { link in
            let left = nodes[link.left - 1].position
            let right = nodes[link.right - 1].position
            let height = left.distance(from: right)
            let cylinder = SCNCylinder(radius: 0.1, height: height)
            let node = SCNNode(geometry: cylinder)
            cylinder.color = .black
            
            /* Caculate link position and orientation */
            node.position = (left + right) / 2
            node.transform = nodeOrientation(left, right)
            ligandNode?.addChildNode(node)
        }
    }
    
    private func nodeOrientation(_ left: SCNVector3, _ right: SCNVector3) -> SCNMatrix4 {
        let lookat = right - left
        let y = lookat.normalized
        let up = lookat.cross(right).normalized
        let x = y.cross(up).normalized
        let z = x.cross(y).normalized
        let transform = SCNMatrix4(x: x, y: y, z: z, w: left)
        return SCNMatrix4MakeTranslation(0, lookat.lenght / 2, 0) * transform
    }
    
    // MARK:- Button handler
    /* Take a snapshot from sceneView and share trought activity controller. */
    @objc func handleShare() {
        let image = sceneView.snapshot()
        let controller = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

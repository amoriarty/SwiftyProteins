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
            generateScene(with: ligand)
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
        // TODO: Remove statistics
        view.showsStatistics = true
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
    private func generateScene(with ligand: Ligand) {
        var atomNodes = [SCNNode]()
        
        /* Calculating offsets to center ligand into scene */
        let offsetX = ligand.atoms.reduce(0) { $0 + $1.position.x } / Float(ligand.atoms.count)
        let offsetY = ligand.atoms.reduce(0) { $0 + $1.position.y } / Float(ligand.atoms.count)
        let offsetZ = ligand.atoms.reduce(0) { $0 + $1.position.z } / Float(ligand.atoms.count)
        
        /* Remove ligand node before rebuild it and re-add it to root node. */
        ligandNode?.removeFromParentNode()
        
        /* Instanciate a new ligandNode object */
        ligandNode = SCNNode()
        
        // TODO: Maybe don't print hydrogens atom, or only when asked.
        
        /* Adding all atoms into ligandNode */
        ligand.atoms.forEach { atom in
            let sphere = SCNSphere()
            let node = SCNNode(geometry: sphere)
            let x = atom.position.x - offsetX
            let y = atom.position.y - offsetY
            let z = atom.position.z - offsetZ
            node.position = SCNVector3(x, y, z)
            sphere.firstMaterial?.diffuse.contents = Colors.CPK[atom.type]
            ligandNode?.addChildNode(node)
            atomNodes.append(node)
        }
        
        /* Adding all links between atoms */
        // TODO: Print multiple connexion when needed.
        ligand.links.forEach { link in
            let left = atomNodes[link.left - 1].position
            let right = atomNodes[link.right - 1].position
            let height = left.distance(from: right)
            let cylinder = SCNCylinder(radius: 0.1, height: height)
            let node = SCNNode(geometry: cylinder)
            cylinder.firstMaterial?.diffuse.contents = UIColor.black
            ligandNode?.addChildNode(node)
            
            /* Caculate link position */
            node.position = (left + right) / 2
            
            /* Calculating node orientation */
            let lookat = right - left
            let newy = lookat.normalized
            let up = lookat.cross(right).normalized
            let newx = newy.cross(up).normalized
            let newz = newx.cross(newy).normalized
            let transform = SCNMatrix4(x: newx, y: newy, z: newz, w: left)
            node.transform = SCNMatrix4MakeTranslation(0, lookat.lenght / 2, 0) * transform
        }
        
        /* Adding ligandNode to scene */
        scene.rootNode.addChildNode(ligandNode!)
    }
    
    // MARK:- Button handler
    @objc func handleShare() {
        // TODO: Implement handle share
    }
}

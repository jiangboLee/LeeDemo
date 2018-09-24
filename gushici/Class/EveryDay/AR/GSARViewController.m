//
//  GSARViewController.m
//  gushici
//
//  Created by LEE on 2018/9/24.
//  Copyright © 2018年 lijiangbo. All rights reserved.
//

#import "GSARViewController.h"
#import <SceneKit/SceneKit.h>
#import <ARKit/ARKit.h>

API_AVAILABLE(ios(11.0))
@interface GSARViewController ()<ARSCNViewDelegate, ARSessionDelegate>

@property (strong, nonatomic) IBOutlet ARSCNView *scnView;
@property (weak,   nonatomic) SCNText *textPlane;
@property (weak,   nonatomic) SCNNode *node;

@end

@implementation GSARViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.scnView.delegate = self;
    self.scnView.showsStatistics = true;
    self.scnView.session.delegate = self;
//    self.scnView.allowsCameraControl = true
//    self.scnView.autoenablesDefaultLighting = true;

//    self.textPlane = [SCNText textWithString:@"你好啊" extrusionDepth:0.01];
//    self.textPlane.font = [UIFont systemFontOfSize:0.15];
//    self.textPlane.firstMaterial.diffuse.contents = [UIColor redColor];
//    self.node = [SCNNode nodeWithGeometry:self.textPlane];
//    self.node.position = SCNVector3Make(0, 0, -2);
////    self.node.eulerAngles = SCNVector3Make(0, 0, 0);
//    self.node.physicsBody = [SCNPhysicsBody staticBody];
//    [_scnView.scene.rootNode addChildNode:self.node];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (@available(iOS 11.0, *)) {
        ARWorldTrackingConfiguration *configuration = [[ARWorldTrackingConfiguration alloc]init];
        if (@available(iOS 11.3, *)) {
            configuration.planeDetection = ARPlaneDetectionVertical;
        }
        [self.scnView.session runWithConfiguration:configuration];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.scnView.session pause];
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didAddNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor  API_AVAILABLE(ios(11.0)){
    if (@available(iOS 11.0, *)) {
        if (self.textPlane == nil && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
            [self createText:(ARPlaneAnchor *)anchor];
            [node addChildNode:self.node];
            NSLog(@"aaaaa");
        }
    }
}

- (void)renderer:(id<SCNSceneRenderer>)renderer didUpdateNode:(SCNNode *)node forAnchor:(ARAnchor *)anchor  API_AVAILABLE(ios(11.0)){
    
    if (@available(iOS 11.0, *)) {
        if (self.textPlane != nil && [anchor isKindOfClass:[ARPlaneAnchor class]]) {
            [self update:(ARPlaneAnchor *)anchor];
            NSLog(@"bbbbbbb");
        }
    }
}

- (void)createText:(ARPlaneAnchor *)planeAnchor  API_AVAILABLE(ios(11.0)){
    self.textPlane = [SCNText textWithString:@"你好啊" extrusionDepth:0.01];
    self.textPlane.font = [UIFont systemFontOfSize:0.15];
    self.textPlane.firstMaterial.diffuse.contents = [UIColor redColor];
    self.node = [SCNNode nodeWithGeometry:self.textPlane];
    NSLog(@"%@",planeAnchor);
    self.node.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z);
    self.node.eulerAngles = SCNVector3Make(GLKMathDegreesToRadians(-90), 0, 0);
    self.node.physicsBody = [SCNPhysicsBody staticBody];
}

- (void)update:(ARPlaneAnchor *)planeAnchor  API_AVAILABLE(ios(11.0)){
    
    self.node.position = SCNVector3Make(planeAnchor.center.x, planeAnchor.center.y, planeAnchor.center.z);
    NSLog(@"%@",planeAnchor);
}

//- (void)session:(ARSession *)session didUpdateFrame:(ARFrame *)frame  API_AVAILABLE(ios(11.0)){
//    self.node.position = SCNVector3Make(frame.camera.transform.columns[3].x, frame.camera.transform.columns[3].y, frame.camera.transform.columns[3].z);
//}
@end

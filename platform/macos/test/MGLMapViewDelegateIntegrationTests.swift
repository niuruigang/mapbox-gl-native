import XCTest
import Mapbox

class MGLMapViewDelegateIntegrationTests: XCTestCase {

    func testCheckTestsContainAllMethods() {
        var subjectMethods = Set<String>()
        var testMethods = Set<String>()

        var delegateMethodCount = UInt32()
        let delegateMethodDescriptionList: UnsafeMutablePointer<objc_method_description>! = protocol_copyMethodDescriptionList(MGLMapViewDelegate.self, false, true, &delegateMethodCount)
        for i in 0..<Int(delegateMethodCount) {
            let description: objc_method_description = delegateMethodDescriptionList[i]
            subjectMethods.insert(description.name.description)

        }
        free(delegateMethodDescriptionList)

        var testMethodCount = UInt32()
        let testMethodList: UnsafeMutablePointer<Method?>! = class_copyMethodList(MGLMapViewDelegateIntegrationTests.self, &testMethodCount)
        for i in 0..<Int(testMethodCount) {
            let method = testMethodList[i]
            let selector : Selector = method_getName(method)
            testMethods.insert(selector.description)
        }
        free(testMethodList)

        for method in subjectMethods {
            if !testMethods.contains(method) {
                XCTFail("\(String(describing: self)) does not contain \(method) from \(String(describing: MGLMapViewDelegate.self))")
            }
        }
        
        XCTAssert(true)
    }
    
}

extension MGLMapViewDelegateIntegrationTests: MGLMapViewDelegate {

    func mapView(_ mapView: MGLMapView, shouldChangeFrom oldCamera: MGLMapCamera, to newCamera: MGLMapCamera) -> Bool { return false }

    func mapView(_ mapView: MGLMapView, lineWidthForPolylineAnnotation annotation: MGLPolyline) -> CGFloat { return 0 }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool { return false }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? { return nil }

    func mapView(_ mapView: MGLMapView, alphaForShapeAnnotation annotation: MGLShape) -> CGFloat { return 0 }

    func mapViewDidFinishRenderingFrame(_ mapView: MGLMapView, fullyRendered: Bool) {}

    func mapViewDidFinishRenderingMap(_ mapView: MGLMapView, fullyRendered: Bool) {}

    func mapViewDidFailLoadingMap(_ mapView: MGLMapView, withError error: Error) {}

    func mapView(_ mapView: MGLMapView, didDeselect annotation: MGLAnnotation) {}

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {}

    func mapView(_ mapView: MGLMapView, didFinishLoading style: MGLStyle) {}

    func mapViewWillStartRenderingFrame(_ mapView: MGLMapView) {}

    func mapViewWillStartRenderingMap(_ mapView: MGLMapView) {}

    func mapViewWillStartLoadingMap(_ mapView: MGLMapView) {}

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {}

    func mapViewCameraIsChanging(_ mapView: MGLMapView) {}

    func mapView(_ mapView: MGLMapView, cameraDidChangeAnimated animated: Bool) {}

    func mapView(_ mapView: MGLMapView, cameraWillChangeAnimated animated: Bool) {}

    func mapView(_ mapView: MGLMapView, strokeColorForShapeAnnotation annotation: MGLShape) -> NSColor { return .black }

    func mapView(_ mapView: MGLMapView, fillColorForPolygonAnnotation annotation: MGLPolygon) -> NSColor { return .black }

    func mapView(_ mapView: MGLMapView, calloutViewControllerFor annotation: MGLAnnotation) -> NSViewController? { return nil }

}

class Eject < Formula
  desc "Generate swift code from Interface Builder xibs"
  homepage "https://github.com/Raizlabs/Eject"
  url "https://github.com/Raizlabs/Eject/archive/0.1.12.tar.gz"
  sha256 "a4dae3d37f780d274f53ed25d9dc1a27d5245289f9b8cbaaf8be71bc9334de18"

  bottle do
    cellar :any
    sha256 "7354ff78be9395237c0fb704e6fea0f51720ef7c55f020e1a4dbf60b09d6eb7b" => :sierra
    sha256 "91d45bc0bee9092525505528cbd77d457e5728c1f4ab3e8c94c3ecf69284adb0" => :el_capitan
  end

  depends_on :xcode => ["8.0", :build]

  def install
    xcodebuild
    bin.install "build/Release/eject.app/Contents/MacOS/eject"
    frameworks_path = "build/Release/eject.app/Contents/Frameworks"
    mv frameworks_path, frameworks
  end

  test do
    (testpath/"view.xib").write <<-EOS.undent
      <?xml version="1.0" encoding="UTF-8" standalone="no"?>
      <document type="com.apple.InterfaceBuilder3.CocoaTouch.XIB" version="3.0" toolsVersion="11134" systemVersion="15F34" targetRuntime="iOS.CocoaTouch" propertyAccessControl="none" useAutolayout="YES" useTraitCollections="YES" colorMatched="YES">
          <dependencies>
              <plugIn identifier="com.apple.InterfaceBuilder.IBCocoaTouchPlugin" version="11106"/>
              <capability name="documents saved in the Xcode 8 format" minToolsVersion="8.0"/>
          </dependencies>
          <objects>
              <placeholder placeholderIdentifier="IBFilesOwner" id="-1" userLabel="File's Owner"/>
              <placeholder placeholderIdentifier="IBFirstResponder" id="-2" customClass="UIResponder"/>
              <view contentMode="scaleToFill" id="iN0-l3-epB">
                  <rect key="frame" x="0.0" y="0.0" width="375" height="667"/>
                  <autoresizingMask key="autoresizingMask" widthSizable="YES" heightSizable="YES"/>
                  <color key="backgroundColor" red="1" green="1" blue="1" alpha="1" colorSpace="custom" customColorSpace="sRGB"/>
              </view>
          </objects>
      </document>
    EOS

    swift = <<-EOS.undent
      // Create Views
      let view = UIView()
      view.frame = CGRect(x: 0, y: 0, width: 375, height: 667)
      view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
      view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    EOS

    assert_equal swift, shell_output("#{bin}/eject --file view.xib")
  end
end

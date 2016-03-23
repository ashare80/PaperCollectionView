#
# Be sure to run `pod lib lint PaperView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PaperCollectionView"
  s.version          = "1.0.1"
  s.summary          = "Collection view that operates similar to Facebook's Paper."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Swipe through content like Paper from Facebook. Using the PaperView, which wraps around a configured UICollectionViewController, you can control the datasource and customize cells to your needs.
                       DESC

  s.homepage         = "https://github.com/ashare80/PaperCollectionView"
  s.screenshots      = "https://s3.amazonaws.com/cocoacontrols_production/uploads/control_image/image/8725/Simulator_Screen_Shot_Mar_22__2016__11.13.52_PM.png"
  s.license          = 'MIT'
  s.author           = { "Adam Share" => "ashare80@gmail.com" }
  s.source           = { :git => "https://github.com/ashare80/PaperCollectionView.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PaperCollectionView' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit'
  s.dependency 'pop'
end

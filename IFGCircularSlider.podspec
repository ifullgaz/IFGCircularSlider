Pod::Spec.new do |s|
  s.name         = 'IFGCircularSlider'
  s.version      = '0.1.0'
  s.license      =  { :type => 'MIT', :file => 'LICENSE' }
  s.authors      =  { 'Emmanuel Merali' => 'emmanuel@merali.me' }
  s.summary      = 'An extensible circular slider for iOS applications'
  s.homepage     = 'https://github.com/ifullgaz/IFGCircularSlider'

# Source Info
  s.platform     =  :ios, '7.0'
  s.source       =  { :git => 'https://github.com/ifullgaz/IFGCircularSlider.git', :tag => "0.1.0" }
  s.source_files = 'IFGCircularSlider/IFGCircularSlider.{h,m}'

  s.requires_arc = true
end

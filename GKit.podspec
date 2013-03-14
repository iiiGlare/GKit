Pod::Spec.new do |s|
  s.name		= 'MBProgressHUD'
  s.version		= '0.1'
  s.summary		= 'An iOS framework.'
  s.description 	= <<-DESC
			DESC
  s.author		= { 'Hua Cao' => 'glare.ch@gmail.com' }
  s.license		= { :type => 'MIT', :file => 'LICENSE' }
  s.platform		= :ios, '5.0'
  s.requires_arc	= true
  s.source		= { :git => "https://github.com/GlareCH/GKit.git"}
  s.source_files	= 'GKit'
  s.framework	= 'AudioToolbox', 'AVFoundation', 'CoreData'
end


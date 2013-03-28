Pod::Spec.new do |s|
  
  s.name		= 'GKit'
  
  s.version		= '0.1'
  
  s.summary		= 'An iOS framework.'
  
  s.author		= { 'Hua Cao' => 'glare.ch@gmail.com' }
  
  s.license		= { :type => 'MIT', :file => 'LICENSE' }
  
  s.platform		= :ios, '5.0'
  
  s.requires_arc	= true
  
  s.source		= { :git => "https://github.com/GlareCH/GKit.git"}
  
  s.subspec 'Audio' do |audio|
    audio.source_files = 'GKit/Audio/**/*.{h,m}'
    audio.frameworks = 'AVFoundation', 'AudioToolbox'
  end
  
  s.subspec 'Camera' do |camera|
    camera.source_files = 'GKit/Camera/**/*.{h,m}'
	camera.frameworks = 'AVFoundation'
  end

  s.subspec 'Core' do |core|
    core.source_files = 'GKit/Core/**/*.{h,m}'
  end

  s.subspec 'CoreData' do |coredata|
    coredata.source_files = 'GKit/CoreData/**/*.{h,m}'
    coredata.frameworks = 'CoreData'
  end
  
  s.subspec 'ImageManager' do |imageManager|
    imageManager.source_files = 'GKit/ImageManager/**/*.{h,m}'
    imageManager.frameworks = 'AssetsLibrary'
  end

  s.subspec 'UI' do |ui|
    ui.source_files = 'GKit/UI/**/*.{h,m}'
  end

end

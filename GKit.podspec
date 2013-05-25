Pod::Spec.new do |s|
  
  s.name		= 'GKit'
  
  s.version		= '0.1'
  
  s.summary		= 'An iOS framework.'
  
  s.author		= { 'Hua Cao' => 'glare.ch@gmail.com' }
  
  s.license		= { :type => 'MIT', :file => 'LICENSE' }
  
  s.platform		= :ios, '5.0'
  
  s.requires_arc	= true
  
  s.source		= { :git => "https://github.com/GlareCH/GKit.git"}

  s.subspec 'AppStore' do |appStore|
    appStore.source_files = 'GKit/AppStore/**/*.{h,m}'
    appStore.frameworks = 'MessageUI', 'StoreKit'
  end

  s.subspec 'Audio' do |audio|
    audio.source_files = 'GKit/Audio/**/*.{h,m}'
    audio.frameworks = 'AVFoundation', 'AudioToolbox', 'MediaPlayer'
  end

  s.subspec 'Calendar' do |calendar|
    calendar.source_files = 'GKit/Calendar/**/*.{h,m}'
  end

  s.subspec 'Camera' do |camera|
    camera.source_files = 'GKit/Camera/**/*.{h,m}'
	camera.frameworks = 'AVFoundation'
  end

  s.subspec 'Core' do |core|
    core.source_files = 'GKit/Core/**/*.{h,m}'
    core.frameworks = 'QuartzCore'
  end

  s.subspec 'CoreData' do |coredata|
    coredata.source_files = 'GKit/CoreData/**/*.{h,m}'
    coredata.frameworks = 'CoreData'
  end
  
  s.subspec 'DataManager' do |dataManager|
    dataManager.source_files = 'GKit/DataManager/**/*.{h,m}'
    dataManager.frameworks = 'AssetsLibrary'
  end

  s.subspec 'Location' do |location|
    location.source_files = 'GKit/Location/**/*.{h,m}'
    location.frameworks = 'CoreLocation'
  end

  s.subspec 'Move' do |move|
    move.source_files = 'GKit/Move/**/*.{h,m}'
  end

  s.subspec 'UI' do |ui|
    ui.source_files = 'GKit/UI/**/*.{h,m}'
    ui.frameworks = 'CoreGraphics'
  end


end

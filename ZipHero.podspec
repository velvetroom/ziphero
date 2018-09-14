Pod::Spec.new do |s|
s.name             = 'ZipHero'
s.version          = '1.0.15'
s.summary          = 'Package your files'
s.description      = <<-DESC
Package and depackage multiple files into 1 single file
DESC
s.homepage         = 'https://github.com/velvetroom/ziphero'
s.license          = { :type => "MIT", :file => "LICENSE" }
s.author           = { 'iturbide' => 'ziphero@iturbi.de' }
s.platform         = :ios, '9.0'
s.source           = { :git => 'https://github.com/velvetroom/ziphero.git', :tag => "v#{s.version}" }
s.source_files     = 'Source/*.swift'
s.swift_version    = '4.2'
s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
s.prefix_header_file = false
s.static_framework = true
end

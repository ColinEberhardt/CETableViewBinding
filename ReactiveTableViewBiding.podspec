Pod::Spec.new do |spec|
  spec.name         = 'ReactiveTableViewBiding'
  spec.version      = '1.0'
  spec.license      = { :type => 'BSD' }
  spec.homepage     = 'https://github.com/ColinEberhardt/CETableViewBinding'
  spec.authors      = { 'Colin Eberhardt' => 'ceberhardt@scottlogic.co.uk' }
  spec.summary      = 'ReactiveCocoa TableView Binding Helper.'
  spec.source       = { :git => 'git@github.com:ColinEberhardt/CETableViewBinding.git', :tag => spec.version.to_s }
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.source_files = '*.{h,m}'
  spec.dependency 'ReactiveCocoa'
  end
Pod::Spec.new do |spec|
  spec.name         = 'ReactiveTableViewBinding'
  spec.version      = '1.0'
  spec.license      = {
    :type => 'MIT',
    :file => 'MIT-LICENSE.txt'
  }
  spec.homepage     = 'https://github.com/ColinEberhardt/CETableViewBinding'
  spec.authors      = {
    'Colin Eberhardt' => 'colin.eberhardt@gmail.com'
  }
  spec.summary      = 'ReactiveCocoa TableView Binding Helper.'
  spec.source       = {
    :git => 'https://github.com/ColinEberhardt/CETableViewBinding.git',
    :tag => 'v1.0.0'
  }
  spec.platform     = :ios, '7.0'
  spec.requires_arc = true
  spec.source_files = '*.{h,m}'
  spec.dependency 'ReactiveCocoa', '~> 2.4'
end
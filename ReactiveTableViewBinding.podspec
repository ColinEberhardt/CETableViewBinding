Pod::Spec.new do |spec|

  spec.name         = 'ReactiveTableViewBinding'
  spec.version      = '1.1'
  spec.license      = {
    :type => 'MIT',
    :file => 'MIT-LICENSE.txt'
  }
  spec.homepage     = 'https://github.com/ColinEberhardt/CETableViewBinding'
  spec.authors      = {
    'Colin Eberhardt' => 'colin.eberhardt@gmail.com'
  }
  spec.summary      = 'ReactiveCocoa TableView Binding Helper.'
  spec.source       = { git: 'https://github.com/ColinEberhardt/CETableViewBinding.git',
                        tag: spec.version.to_s }
  spec.platform     = :ios, '8.0'
  spec.requires_arc = true
  spec.source_files = '*.{h,m}'
  spec.dependency 'ReactiveObjC', '~> 1.0'

end

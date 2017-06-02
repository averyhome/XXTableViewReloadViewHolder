Pod::Spec.new do |s|
    s.name         = 'XXTableViewReloadViewHolder'
    s.version      = '1.0.0'
    s.summary      = 'An easy way to use tableview net  no dota'
    s.homepage     = 'https://github.com/xuxueing/XXTableViewReloadViewHolder'
    s.license      = 'MIT'
    s.authors      = {'朱小亮' => '330578304@qq.com'}
    s.platform     = :ios, '6.0'
    s.source       = {:git => 'https://github.com/xuxueing/XXTableViewReloadViewHolder.git', :tag => s.version}
    s.source_files = 'XXTableViewReloadViewHolder/Reachability/*.{h,m}','XXTableViewReloadViewHolder/*.{h,m}'
    s.resource     = 'XXTableViewReloadViewHolder/xxSourceBundle.bundle'
    s.frameworks   = 'Foundation','UIKit','SystemConfiguration'
    s.requires_arc = true
end

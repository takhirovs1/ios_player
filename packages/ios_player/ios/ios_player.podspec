Pod::Spec.new do |s|
  s.name             = 'ios_player'
  s.module_name      = 'ios_player'
  s.version          = '0.0.1'
  s.summary          = 'SwiftUI-based iOS video player for Flutter'
  s.static_framework = true               # ← Swift учун tavsiya
  s.source_files     = 'Classes/**/*'
  s.platform         = :ios, '15.6'
  s.dependency       'Flutter'            # ← мана шу муҳим
  s.swift_version    = '5.0'
end

platform :ios, '9.0'
workspace 'MyDesignPatternsWS'
targetsArray = ['NormalMVC', 'StandMVC', 'MVP', 'MVVM']
# 循环
targetsArray.each do |t|
        target t do
                pod 'Masonry'
                pod 'YYKit'
                pod 'ReactiveObjC'
                pod 'AFNetworking'
                pod 'KVOController'
                project "#{t}/#{t}.xcodeproj"
#                pod 'Reveal-SDK', :configurations => ['Debug']
        end
end

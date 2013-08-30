
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_target "dream-display-ios" do |target|
	target.build do |environment|
		build_directory(package.path, 'source', environment)
	end
	
	target.depends "Library/Dream"
	
	target.provides "Library/Dream/Display" => "Library/Dream/DisplayIOS"
	
	target.provides "Library/Dream/DisplayIOS" do
		append linkflags "-lDreamDisplayIOS"
	end
end

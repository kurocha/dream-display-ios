
#
#  This file is part of the "Teapot" project, and is released under the MIT license.
#

teapot_version "0.8.0"

define_target "dream-display-ios" do |target|
	target.build do |environment|
		build_directory(package.path, 'source', environment)
	end
	
	target.depends "Library/Dream/Display"
	
	target.provides "Library/Dream/Display/Context" => "Library/Dream/Display/IOS"
	target.provides "Library/Dream/Client/Display" => "Library/Dream/Display/IOS"
	
	target.provides "Library/Dream/Display/IOS" do
		append linkflags "-lDreamDisplayIOS"
	end
end

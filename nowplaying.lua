-- This version was tested using VLC version 2.2.1 --

--[[
INSTALLATION:
Put the file in the VLC subdir /lua/extensions, by default:
* Windows (all users): C:\Program Files (x86)\VideoLAN\VLC\lua\extensions
* Windows (current user): C:\Users\USER\AppData\Roaming\vlc\lua\extensions
To load extension simply restart VLC or from the menu bar Tools -> Plugins and extensions -> Active extensions click Reload extensions
Activate the extension by going to the "View" menu and click on "Now Playing Radio: Write song name and artist to file."
--]]

-- Loads required libraries
require "io"
require "string"

-- VLC Extension Descriptor
function descriptor()
	return {
				title = "Now Playing Radio";
				version = "0.1";
				author = "J-Witz";
				url = 'https://github.com/j-witz';
				shortdesc = "Now Playing Radio: Write song name and artist to file.";
				description = "Writes the current song name and artist to a text file.<br />"
							.."(Based on the script made by Richard Andrew Cattermole)<br />"
							.."(https://gist.github.com/rikkimax)<br />"
							.."(Modified by J-Witz)";
				capabilities = { "meta-listener" };
			}
end

-- This function is triggered when the extension is activated
function activate()
	vlc.msg.dbg("[Now Playing Radio] Activated")
	handleItem()
	return true
end

-- This function is triggered when the extension is deactivated
function deactivate()
	vlc.msg.dbg("[Now Playing Radio] Deactivated")
	return true
end

-- Triggered by change in input meta
function meta_changed()
	handleItem()
end

-- Reads artist and title information and writes them to the text file
function handleItem()
	local item = vlc.item or vlc.input.item()
	local artistFile=vlc.config.homedir() .. "/now_playing_artist.txt"
	local titleFile=vlc.config.homedir() .. "/now_playing_title.txt"
	local artistFile2 = io.open(artistFile, "w+")
	local titleFile2 = io.open(titleFile, "w+")
	if not (item == nil) and vlc.input.is_playing() then  
		local metas = item:metas()
		local artist, title = string.match(metas.now_playing,'^%s*(.-)%s*%-%s*(.-)%s*$')
		local artistText = "Artist: "..artist
		local titleText = "Title: "..title
		artistFile2:write(artistText)
		titleFile2:write(titleText)
	else
		artistFile2:write("No song currently playing")
		titleFile2:write("No song currently playing")
	end
	artistFile2:close()
	titleFile2:close()
end

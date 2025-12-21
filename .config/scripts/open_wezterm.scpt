set appName to "WezTerm"

if application appName is running then
	do shell script "/Applications/WezTerm.app/Contents/MacOS/wezterm-gui"
else
	do shell script "open -a WezTerm"
end if

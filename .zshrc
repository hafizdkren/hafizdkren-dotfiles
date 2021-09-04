#   (Disabling this to making P10K work out)

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
#   if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#     source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
#   fi

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
setopt autocd extendedglob nomatch notify
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/hafizdkren/.zshrc'

autoload -Uz compinit promptinit
compinit -i
promptinit

zstyle ':completion:*:*:cd:*' menu yes select
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s%p
zstyle ':completion:*' menu yes select
# End of lines added by compinstall

#SSH-GPG Automate
    export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    gpgconf --launch gpg-agent

#DOTNET
    export PATH=$PATH:$HOME/dotnet
    export DOTNET_ROOT=$HOME/dotnet

#Keybinds
    bindkey  "^[[H"   beginning-of-line
    bindkey  "^[[F"   end-of-line
    bindkey '^[[1;5C' forward-word
    bindkey '^[[1;5D' backward-word
    bindkey   "^H"    backward-delete-word
    bindkey "^[[3;5~" delete-word
    bindkey  "^[[5~"  up-line
    bindkey  "^[[6~"  down-line
    bindkey -s '^ ' ' gh pr status && gh issue status'
#    bindkey   '^M'    autosuggest-execute      #(Disable the comment to activating autosuggest-execute if it's installed)
    bindkey  '^[[3~'  delete-char


#compdef _gh gh

# zsh completion for gh                                   -*- shell-script -*-

__gh_debug()
{
    local file="$BASH_COMP_DEBUG_FILE"
    if [[ -n ${file} ]]; then
        echo "$*" >> "${file}"
    fi
}

_gh()
{
    local shellCompDirectiveError=1
    local shellCompDirectiveNoSpace=2
    local shellCompDirectiveNoFileComp=4
    local shellCompDirectiveFilterFileExt=8
    local shellCompDirectiveFilterDirs=16

    local lastParam lastChar flagPrefix requestComp out directive comp lastComp noSpace
    local -a completions

    __gh_debug "\n========= starting completion logic =========="
    __gh_debug "CURRENT: ${CURRENT}, words[*]: ${words[*]}"

    # The user could have moved the cursor backwards on the command-line.
    # We need to trigger completion from the $CURRENT location, so we need
    # to truncate the command-line ($words) up to the $CURRENT location.
    # (We cannot use $CURSOR as its value does not work when a command is an alias.)
    words=("${=words[1,CURRENT]}")
    __gh_debug "Truncated words[*]: ${words[*]},"

    lastParam=${words[-1]}
    lastChar=${lastParam[-1]}
    __gh_debug "lastParam: ${lastParam}, lastChar: ${lastChar}"

    # For zsh, when completing a flag with an = (e.g., gh -n=<TAB>)
    # completions must be prefixed with the flag
    setopt local_options BASH_REMATCH
    if [[ "${lastParam}" =~ '-.*=' ]]; then
        # We are dealing with a flag with an =
        flagPrefix="-P ${BASH_REMATCH}"
    fi

    # Prepare the command to obtain completions
    requestComp="${words[1]} __complete ${words[2,-1]}"
    if [ "${lastChar}" = "" ]; then
        # If the last parameter is complete (there is a space following it)
        # We add an extra empty parameter so we can indicate this to the go completion code.
        __gh_debug "Adding extra empty parameter"
        requestComp="${requestComp} \"\""
    fi

    __gh_debug "About to call: eval ${requestComp}"

    # Use eval to handle any environment variables and such
    out=$(eval ${requestComp} 2>/dev/null)
    __gh_debug "completion output: ${out}"

    # Extract the directive integer following a : from the last line
    local lastLine
    while IFS='\n' read -r line; do
        lastLine=${line}
    done < <(printf "%s\n" "${out[@]}")
    __gh_debug "last line: ${lastLine}"

    if [ "${lastLine[1]}" = : ]; then
        directive=${lastLine[2,-1]}
        # Remove the directive including the : and the newline
        local suffix
        (( suffix=${#lastLine}+2))
        out=${out[1,-$suffix]}
    else
        # There is no directive specified.  Leave $out as is.
        __gh_debug "No directive found.  Setting do default"
        directive=0
    fi

    __gh_debug "directive: ${directive}"
    __gh_debug "completions: ${out}"
    __gh_debug "flagPrefix: ${flagPrefix}"

    if [ $((directive & shellCompDirectiveError)) -ne 0 ]; then
        __gh_debug "Completion received error. Ignoring completions."
        return
    fi

    while IFS='\n' read -r comp; do
        if [ -n "$comp" ]; then
            # If requested, completions are returned with a description.
            # The description is preceded by a TAB character.
            # For zsh's _describe, we need to use a : instead of a TAB.
            # We first need to escape any : as part of the completion itself.
            comp=${comp//:/\\:}

            local tab=$(printf '\t')
            comp=${comp//$tab/:}

            __gh_debug "Adding completion: ${comp}"
            completions+=${comp}
            lastComp=$comp
        fi
    done < <(printf "%s\n" "${out[@]}")

    if [ $((directive & shellCompDirectiveNoSpace)) -ne 0 ]; then
        __gh_debug "Activating nospace."
        noSpace="-S ''"
    fi

    if [ $((directive & shellCompDirectiveFilterFileExt)) -ne 0 ]; then
        # File extension filtering
        local filteringCmd
        filteringCmd='_files'
        for filter in ${completions[@]}; do
            if [ ${filter[1]} != '*' ]; then
                # zsh requires a glob pattern to do file filtering
                filter="\*.$filter"
            fi
            filteringCmd+=" -g $filter"
        done
        filteringCmd+=" ${flagPrefix}"

        __gh_debug "File filtering command: $filteringCmd"
        _arguments '*:filename:'"$filteringCmd"
    elif [ $((directive & shellCompDirectiveFilterDirs)) -ne 0 ]; then
        # File completion for directories only
        local subDir
        subdir="${completions[1]}"
        if [ -n "$subdir" ]; then
            __gh_debug "Listing directories in $subdir"
            pushd "${subdir}" >/dev/null 2>&1
        else
            __gh_debug "Listing directories in ."
        fi

        local result
        _arguments '*:dirname:_files -/'" ${flagPrefix}"
        result=$?
        if [ -n "$subdir" ]; then
            popd >/dev/null 2>&1
        fi
        return $result
    else
        __gh_debug "Calling _describe"
        if eval _describe "completions" completions $flagPrefix $noSpace; then
            __gh_debug "_describe found some completions"

            # Return the success of having called _describe
            return 0
        else
            __gh_debug "_describe did not find completions."
            __gh_debug "Checking if we should do file completion."
            if [ $((directive & shellCompDirectiveNoFileComp)) -ne 0 ]; then
                __gh_debug "deactivating file completion"

                # We must return an error code here to let zsh know that there were no
                # completions found by _describe; this is what will trigger other
                # matching algorithms to attempt to find completions.
                # For example zsh can match letters in the middle of words.
                return 1
            else
                # Perform file completion
                __gh_debug "Activating file completion"

                # We must return the result of this command, so it must be the
                # last command, or else we must store its result to return it.
                _arguments '*:filename:_files'" ${flagPrefix}"
            fi
        fi
    fi
}

# don't run the completion function when being source-ed or eval-ed
if [ "$funcstack[1]" = "_gh" ]; then
	_gh
fi

# VS Code (stable / insiders) / VSCodium zsh plugin
# Authors:
#   https://github.com/MarsiBarsi (original author)
#   https://github.com/babakks
#   https://github.com/SteelShot

# Verify if any manual user choice of VS Code exists first.
if [[ -n "$VSCODE" ]] && ! which $VSCODE &>/dev/null; then
  echo "'$VSCODE' flavour of VS Code not detected."
  unset VSCODE
fi

# Otherwise, try to detect a flavour of VS Code.
if [[ -z "$VSCODE" ]]; then
  if which code &>/dev/null; then
    VSCODE=code
  elif which code-insiders &>/dev/null; then
    VSCODE=code-insiders
  elif which codium &>/dev/null; then
    VSCODE=codium
  else
    return
  fi
fi

alias vsc="$VSCODE ."
alias vsca="$VSCODE --add"
alias vscd="$VSCODE --diff"
alias vscg="$VSCODE --goto"
alias vscn="$VSCODE --new-window"
alias vscr="$VSCODE --reuse-window"
alias vscw="$VSCODE --wait"
alias vscu="$VSCODE --user-data-dir"

alias vsced="$VSCODE --extensions-dir"
alias vscie="$VSCODE --install-extension"
alias vscue="$VSCODE --uninstall-extension"

alias vscv="$VSCODE --verbose"
alias vscl="$VSCODE --log"
alias vscde="$VSCODE --disable-extensions"

#!/usr/bin/env bash

function spotify() {
# Copyright (c) 2012--2019 Harish Narayanan <mail@harishnarayanan.org>
#
# Contains numerous helpful contributions from Jorge Colindres, Thomas
# Pritchard, iLan Epstein, Gabriele Bonetti, Sean Heller, Eric Martin
# and Peter Fonseca.

# Permission is hereby granted, free of charge, to any person
# obtaining a copy of this software and associated documentation files
# (the "Software"), to deal in the Software without restriction,
# including without limitation the rights to use, copy, modify, merge,
# publish, distribute, sublicense, and/or sell copies of the Software,
# and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:

# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
# BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
# ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

USER_CONFIG_DEFAULTS="CLIENT_ID=\"\"\nCLIENT_SECRET=\"\"";
USER_CONFIG_FILE="${HOME}/.shpotify.cfg";
if ! [[ -f "${USER_CONFIG_FILE}" ]]; then
    touch "${USER_CONFIG_FILE}";
    echo -e "${USER_CONFIG_DEFAULTS}" > "${USER_CONFIG_FILE}";
fi
source "${USER_CONFIG_FILE}";

showAPIHelp() {
    echo;
    echo "Connecting to Spotify's API:";
    echo;
    echo "  This command line application needs to connect to Spotify's API in order to";
    echo "  find music by name. It is very likely you want this feature!";
    echo;
    echo "  To get this to work, you need to sign up (or in) and create an 'Application' at:";
    echo "  https://developer.spotify.com/my-applications/#!/applications/create";
    echo;
    echo "  Once you've created an application, find the 'Client ID' and 'Client Secret'";
    echo "  values, and enter them into your shpotify config file at '${USER_CONFIG_FILE}'";
    echo;
    echo "  Be sure to quote your values and don't add any extra spaces!";
    echo "  When done, it should look like this (but with your own values):";
    echo '  CLIENT_ID="abc01de2fghijk345lmnop"';
    echo '  CLIENT_SECRET="qr6stu789vwxyz"';
}

showHelp () {
    echo "Usage:";
    echo;
    echo "  `basename $0` <command>";
    echo;
    echo "Commands:";
    echo;
    echo "  play                         # Resumes playback where Spotify last left off.";
    echo "  play <song name>             # Finds a song by name and plays it.";
    echo "  play album <album name>      # Finds an album by name and plays it.";
    echo "  play artist <artist name>    # Finds an artist by name and plays it.";
    echo "  play list <playlist name>    # Finds a playlist by name and plays it.";
    echo "  play uri <uri>               # Play songs from specific uri.";
    echo;
    echo "  next                         # Skips to the next song in a playlist.";
    echo "  prev                         # Returns to the previous song in a playlist.";
    echo "  replay                       # Replays the current track from the beginning.";
    echo "  pos <time>                   # Jumps to a time (in secs) in the current song.";
    echo "  pause                        # Pauses (or resumes) Spotify playback.";
    echo "  stop                         # Stops playback.";
    echo "  quit                         # Stops playback and quits Spotify.";
    echo;
    echo "  vol up                       # Increases the volume by 10%.";
    echo "  vol down                     # Decreases the volume by 10%.";
    echo "  vol <amount>                 # Sets the volume to an amount between 0 and 100.";
    echo "  vol [show]                   # Shows the current Spotify volume.";
    echo;
    echo "  status                       # Shows the current player status.";
    echo "  status artist                # Shows the currently playing artist.";
    echo "  status album                 # Shows the currently playing album.";
    echo "  status track                 # Shows the currently playing track.";
    echo;
    echo "  share                        # Displays the current song's Spotify URL and URI."
    echo "  share url                    # Displays the current song's Spotify URL and copies it to the clipboard."
    echo "  share uri                    # Displays the current song's Spotify URI and copies it to the clipboard."
    echo;
    echo "  toggle shuffle               # Toggles shuffle playback mode.";
    echo "  toggle repeat                # Toggles repeat playback mode.";
    showAPIHelp
}

cecho(){
    bold=$(tput bold);
    green=$(tput setaf 2);
    reset=$(tput sgr0);
    echo $bold$green"$1"$reset;
}

showArtist() {
    echo `osascript -e 'tell application "Spotify" to artist of current track as string'`;
}

showAlbum() {
    echo `osascript -e 'tell application "Spotify" to album of current track as string'`;
}

showTrack() {
    echo `osascript -e 'tell application "Spotify" to name of current track as string'`;
}

showStatus () {
    state=`osascript -e 'tell application "Spotify" to player state as string'`;
    cecho "Spotify is currently $state.";
    duration=`osascript -e 'tell application "Spotify"
            set durSec to (duration of current track / 1000) as text
            set tM to (round (durSec / 60) rounding down) as text
            if length of ((durSec mod 60 div 1) as text) is greater than 1 then
                set tS to (durSec mod 60 div 1) as text
            else
                set tS to ("0" & (durSec mod 60 div 1)) as text
            end if
            set myTime to tM as text & ":" & tS as text
            end tell
            return myTime'`;
    position=`osascript -e 'tell application "Spotify"
            set pos to player position
            set nM to (round (pos / 60) rounding down) as text
            if length of ((round (pos mod 60) rounding down) as text) is greater than 1 then
                set nS to (round (pos mod 60) rounding down) as text
            else
                set nS to ("0" & (round (pos mod 60) rounding down)) as text
            end if
            set nowAt to nM as text & ":" & nS as text
            end tell
            return nowAt'`;

    echo -e $reset"Artist: $(showArtist)\nAlbum: $(showAlbum)\nTrack: $(showTrack) \nPosition: $position / $duration";
}

if [ $# = 0 ]; then
    showHelp;
else
	if [ ! -d /Applications/Spotify.app ] && [ ! -d $HOME/hafizdkren/.polybar-plugins/spotify ]; then
		echo "The Spotify application must be installed."
		return 1
	fi

    if [ $(osascript -e 'application "Spotify" is running') = "false" ]; then
        osascript -e 'tell application "Spotify" to activate' || return 1
        sleep 2
    fi
fi
while [ $# -gt 0 ]; do
    arg=$1;

    case $arg in
        "play"    )
            if [ $# != 1 ]; then
                # There are additional arguments, so find out how many
                array=( $@ );
                len=${#array[@]};
                SPOTIFY_SEARCH_API="https://api.spotify.com/v1/search";
                SPOTIFY_TOKEN_URI="https://accounts.spotify.com/api/token";
                if [ -z "${CLIENT_ID}" ]; then
                    cecho "Invalid Client ID, please update ${USER_CONFIG_FILE}";
                    showAPIHelp;
                    return 1
                fi
                if [ -z "${CLIENT_SECRET}" ]; then
                    cecho "Invalid Client Secret, please update ${USER_CONFIG_FILE}";
                    showAPIHelp;
                    return 1
                fi
                SHPOTIFY_CREDENTIALS=$(printf "${CLIENT_ID}:${CLIENT_SECRET}" | base64 | tr -d "\n"|tr -d '\r');
                SPOTIFY_PLAY_URI="";

                getAccessToken() {
                    cecho "Connecting to Spotify's API";

                    SPOTIFY_TOKEN_RESPONSE_DATA=$( \
                        curl "${SPOTIFY_TOKEN_URI}" \
                            --silent \
                            -X "POST" \
                            -H "Authorization: Basic ${SHPOTIFY_CREDENTIALS}" \
                            -d "grant_type=client_credentials" \
                    )
                    if ! [[ "${SPOTIFY_TOKEN_RESPONSE_DATA}" =~ "access_token" ]]; then
                        cecho "Autorization failed, please check ${USER_CONFG_FILE}"
                        cecho "${SPOTIFY_TOKEN_RESPONSE_DATA}"
                        showAPIHelp
                        return 1
                    fi
                    SPOTIFY_ACCESS_TOKEN=$( \
                        printf "${SPOTIFY_TOKEN_RESPONSE_DATA}" \
                        | grep -E -o '"access_token":".*",' \
                        | sed 's/"access_token"://g' \
                        | sed 's/"//g' \
                        | sed 's/,.*//g' \
                    )
                }

                searchAndPlay() {
                    type="$1"
                    Q="$2"

                    getAccessToken;

                    cecho "Searching ${type}s for: $Q";

                    SPOTIFY_PLAY_URI=$( \
                        curl -s -G $SPOTIFY_SEARCH_API \
                            -H "Authorization: Bearer ${SPOTIFY_ACCESS_TOKEN}" \
                            -H "Accept: application/json" \
                            --data-urlencode "q=$Q" \
                            -d "type=$type&limit=1&offset=0" \
                        | grep -E -o "spotify:$type:[a-zA-Z0-9]+" -m 1
                    )
                    echo "play uri: ${SPOTIFY_PLAY_URI}"
                }

                case $2 in
                    "list"  )
                        _args=${array[@]:2:$len};
                        Q=$_args;

                        getAccessToken;

                        cecho "Searching playlists for: $Q";

                        results=$( \
                            curl -s -G $SPOTIFY_SEARCH_API --data-urlencode "q=$Q" -d "type=playlist&limit=10&offset=0" -H "Accept: application/json" -H "Authorization: Bearer ${SPOTIFY_ACCESS_TOKEN}" \
                            | grep -E -o "spotify:playlist:[a-zA-Z0-9]+" -m 10 \
                        )

                        count=$( \
                            echo "$results" | grep -c "spotify:playlist" \
                        )

                        if [ "$count" -gt 0 ]; then
                            random=$(( $RANDOM % $count));

                            SPOTIFY_PLAY_URI=$( \
                                echo "$results" | awk -v random="$random" '/spotify:playlist:[a-zA-Z0-9]+/{i++}i==random{print; exit}' \
                            )
                        fi;;

                    "album" | "artist" | "track"    )
                        _args=${array[@]:2:$len};
                        searchAndPlay $2 "$_args";;

                    "uri"  )
                        SPOTIFY_PLAY_URI=${array[@]:2:$len};;

                    *   )
                        _args=${array[@]:1:$len};
                        searchAndPlay track "$_args";;
                esac

                if [ "$SPOTIFY_PLAY_URI" != "" ]; then
                    if [ "$2" = "uri" ]; then
                        cecho "Playing Spotify URI: $SPOTIFY_PLAY_URI";
                    else
                        cecho "Playing ($Q Search) -> Spotify URI: $SPOTIFY_PLAY_URI";
                    fi

                    osascript -e "tell application \"Spotify\" to play track \"$SPOTIFY_PLAY_URI\"";

                else
                    cecho "No results when searching for $Q";
                fi

            else

                # play is the only param
                cecho "Playing Spotify.";
                osascript -e 'tell application "Spotify" to play';
            fi
            break ;;

        "pause"    )
            state=`osascript -e 'tell application "Spotify" to player state as string'`;
            if [ $state = "playing" ]; then
              cecho "Pausing Spotify.";
            else
              cecho "Playing Spotify.";
            fi

            osascript -e 'tell application "Spotify" to playpause';
            break ;;

        "stop"    )
            state=`osascript -e 'tell application "Spotify" to player state as string'`;
            if [ $state = "playing" ]; then
              cecho "Pausing Spotify.";
              osascript -e 'tell application "Spotify" to playpause';
            else
              cecho "Spotify is already stopped."
            fi

            break ;;

        "quit"    ) cecho "Quitting Spotify.";
            osascript -e 'tell application "Spotify" to quit';
            break ;;

        "next"    ) cecho "Going to next track." ;
            osascript -e 'tell application "Spotify" to next track';
            showStatus;
            break ;;

        "prev"    ) cecho "Going to previous track.";
            osascript -e '
            tell application "Spotify"
                set player position to 0
                previous track
            end tell';
            showStatus;
            break ;;

        "replay"  ) cecho "Replaying current track.";
            osascript -e 'tell application "Spotify" to set player position to 0'
            break ;;

        "vol"    )
            vol=`osascript -e 'tell application "Spotify" to sound volume as integer'`;
            if [[ $2 = "" || $2 = "show" ]]; then
                cecho "Current Spotify volume level is $vol.";
                break ;
            elif [ "$2" = "up" ]; then
                if [ $vol -le 90 ]; then
                    newvol=$(( vol+10 ));
                    cecho "Increasing Spotify volume to $newvol.";
                else
                    newvol=100;
                    cecho "Spotify volume level is at max.";
                fi
            elif [ "$2" = "down" ]; then
                if [ $vol -ge 10 ]; then
                    newvol=$(( vol-10 ));
                    cecho "Reducing Spotify volume to $newvol.";
                else
                    newvol=0;
                    cecho "Spotify volume level is at min.";
                fi
            elif [[ $2 =~ ^[0-9]+$ ]] && [[ $2 -ge 0 && $2 -le 100 ]]; then
                newvol=$2;
                cecho "Setting Spotify volume level to $newvol";
            else
                echo "Improper use of 'vol' command"
                echo "The 'vol' command should be used as follows:"
                echo "  vol up                       # Increases the volume by 10%.";
                echo "  vol down                     # Decreases the volume by 10%.";
                echo "  vol [amount]                 # Sets the volume to an amount between 0 and 100.";
                echo "  vol                          # Shows the current Spotify volume.";
                return 1
            fi

            osascript -e "tell application \"Spotify\" to set sound volume to $newvol";
            break ;;

        "toggle"  )
            if [ "$2" = "shuffle" ]; then
                osascript -e 'tell application "Spotify" to set shuffling to not shuffling';
                curr=`osascript -e 'tell application "Spotify" to shuffling'`;
                cecho "Spotify shuffling set to $curr";
            elif [ "$2" = "repeat" ]; then
                osascript -e 'tell application "Spotify" to set repeating to not repeating';
                curr=`osascript -e 'tell application "Spotify" to repeating'`;
                cecho "Spotify repeating set to $curr";
            fi
            break ;;

        "status" )
            if [ $# != 1 ]; then
                # There are additional arguments, a status subcommand
                case $2 in
                    "artist" )
                        showArtist;
                        break ;;

                    "album" )
                        showAlbum;
                        break ;;

                    "track" )
                        showTrack;
                        break ;;
                esac
            else
                # status is the only param
                showStatus;
            fi
            break ;;

        "info" )
            info=`osascript -e 'tell application "Spotify"
                set durSec to (duration of current track / 1000)
                set tM to (round (durSec / 60) rounding down) as text
                if length of ((durSec mod 60 div 1) as text) is greater than 1 then
                    set tS to (durSec mod 60 div 1) as text
                else
                    set tS to ("0" & (durSec mod 60 div 1)) as text
                end if
                set myTime to tM as text & "min " & tS as text & "s"
                set pos to player position
                set nM to (round (pos / 60) rounding down) as text
                if length of ((round (pos mod 60) rounding down) as text) is greater than 1 then
                    set nS to (round (pos mod 60) rounding down) as text
                else
                    set nS to ("0" & (round (pos mod 60) rounding down)) as text
                end if
                set nowAt to nM as text & "min " & nS as text & "s"
                set info to "" & "\nArtist:         " & artist of current track
                set info to info & "\nTrack:          " & name of current track
                set info to info & "\nAlbum Artist:   " & album artist of current track
                set info to info & "\nAlbum:          " & album of current track
                set info to info & "\nSeconds:        " & durSec
                set info to info & "\nSeconds played: " & pos
                set info to info & "\nDuration:       " & mytime
                set info to info & "\nNow at:         " & nowAt
                set info to info & "\nPlayed Count:   " & played count of current track
                set info to info & "\nTrack Number:   " & track number of current track
                set info to info & "\nPopularity:     " & popularity of current track
                set info to info & "\nId:             " & id of current track
                set info to info & "\nSpotify URL:    " & spotify url of current track
                set info to info & "\nArtwork:        " & artwork url of current track
                set info to info & "\nPlayer:         " & player state
                set info to info & "\nVolume:         " & sound volume
                set info to info & "\nShuffle:        " & shuffling
                set info to info & "\nRepeating:      " & repeating
            end tell
            return info'`
            cecho "$info";
            break ;;

        "share"     )
            uri=`osascript -e 'tell application "Spotify" to spotify url of current track'`;
            remove='spotify:track:'
            url=${uri#$remove}
            url="https://open.spotify.com/track/$url"

            if [ "$2" = "" ]; then
                cecho "Spotify URL: $url"
                cecho "Spotify URI: $uri"
                echo "To copy the URL or URI to your clipboard, use:"
                echo "\`spotify share url\` or"
                echo "\`spotify share uri\` respectively."
            elif [ "$2" = "url" ]; then
                cecho "Spotify URL: $url";
                echo -n $url | pbcopy
            elif [ "$2" = "uri" ]; then
                cecho "Spotify URI: $uri";
                echo -n $uri | pbcopy
            fi
            break ;;

        "pos"   )
            cecho "Adjusting Spotify play position."
            osascript -e "tell application \"Spotify\" to set player position to $2";
            break ;;

        "help" )
            showHelp;
            break ;;

        * )
            showHelp;
            return 1 ;;

    esac
done
}

source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

# To easily setting up P10K, you should build from from GH,
# Link to P10K Installations : https://github.com/romkatv/powerlevel10k

source ~/.powerlevel10k/powerlevel10k.zsh-theme

#   source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
#   
# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
#   [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

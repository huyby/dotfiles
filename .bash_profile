# Add `~/bin` to the `$PATH`
export PATH="$HOME/bin:$PATH"
# Make sure local bin are available
export PATH="/usr/local/bin:$PATH"
# Make sure local sbin are available
export PATH="/usr/local/sbin:$PATH"
# Tools globally installed with composer, like phpunit, phpmd
export PATH="$HOME/.composer/vendor/bin:$PATH"
# Ruby installed by Brew
#export PATH="/usr/local/opt/ruby/bin:$PATH"

# Load the shell dotfiles, and then some:
# * ~/.path can be used to extend `$PATH`.
# * ~/.extra can be used for other settings you don’t want to commit.
for file in ~/.{path,bash_prompt,exports,aliases,functions,extra}; do
	[ -r "$file" ] && [ -f "$file" ] && source "$file";
done;
unset file;

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob;

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Autocorrect typos in path names when using `cd`
shopt -s cdspell;

# Enable some Bash 4 features when possible:
# * `autocd`, e.g. `**/qux` will enter `./foo/bar/baz/qux`
# * Recursive globbing, e.g. `echo **/*.txt`
for option in autocd globstar; do
	shopt -s "$option" 2> /dev/null;
done;

# Add tab completion for many Bash commands
if which brew &> /dev/null && [ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]; then
    # Ensure existing Homebrew v1 completions continue to work
    export BASH_COMPLETION_COMPAT_DIR="$(brew --prefix)/etc/bash_completion.d";
    source "$(brew --prefix)/etc/profile.d/bash_completion.sh";
elif [ -f /etc/bash_completion ]; then
    source /etc/bash_completion;
fi;

# Enable tab completion for `g` by marking it as an alias for `git`
if type _git &> /dev/null; then
    complete -o default -o nospace -F _git g;
fi;

# Enable tab completion for `dc` by marking it as an alias for `docker-compose`
if type _docker-compose &> /dev/null && [ -f /usr/local/etc/bash_completion.d/docker-compose ]; then
	complete -o default -o nospace -F _docker-compose dc;
fi;


# Add tab completion for SSH hostnames based on ~/.ssh/config, ignoring wildcards
[ -e "$HOME/.ssh/config" ] && complete -o "default" -o "nospace" -W "$(grep "^Host" ~/.ssh/config | grep -v "[?*]" | cut -d " " -f2- | tr ' ' '\n')" scp sftp ssh;

# Add tab completion for `defaults read|write NSGlobalDomain`
# You could just use `-g` instead, but I like being explicit
complete -W "NSGlobalDomain" defaults;

# Add `killall` tab completion for common apps
complete -o "nospace" -W "Contacts Calendar Dock Finder Mail Safari iTunes SystemUIServer Terminal Twitter" killall

# Add sudo tab completion
complete -cf sudo

# If possible, add tab completion for many more commands
if which brew > /dev/null; then
    for file in $(brew --prefix)/etc/bash_completion.d/*; do
        [ -r "$file" ] && [ -f "$file" ] && source "$file"
    done
fi

# Keep permanent history in logs
export PROMPT_COMMAND='if [ "$(id -u)" -ne 0 ]; then echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >> ~/.logs/bash-history-$(date "+%Y-%m-%d").log; fi'

# Tmuxp completion
if which tmuxp > /dev/null; then
  eval "$(_TMUXP_COMPLETE=source tmuxp)"
fi

# Use non-outdated openssl binaries.
export PATH="/usr/local/opt/openssl/bin:$PATH"

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
#[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

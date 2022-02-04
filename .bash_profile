export PATH="/usr/local/sbin:$PATH"

# Homebrew configuration
if type brew &>/dev/null
then
  HOMEBREW_PREFIX="$(brew --prefix)"
  if [[ -r "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh" ]]
  then
    source "${HOMEBREW_PREFIX}/etc/profile.d/bash_completion.sh"
  else
    for COMPLETION in "${HOMEBREW_PREFIX}/etc/bash_completion.d/"*
    do
      [[ -r "${COMPLETION}" ]] && source "${COMPLETION}"
    done
  fi
fi

# QT5 configuration (homebrew)
export PATH="/usr/local/opt/qt/bin:$PATH"
export LDFLAGS="$LDFLAGS -L/usr/local/opt/qt/lib"
export CPPFLAGS="$CPPFLAGS -I/usr/local/opt/qt/include"
export PKG_CONFIG_PATH="/usr/local/opt/qt/lib/pkgconfig:$PKG_CONFIG_PATH"

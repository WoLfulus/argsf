declare _ARGCOUNT=$#
declare _ARGDATA=("$@")
declare -A _ARGMAP
declare -A _FLAGMAP

while [ $# -gt 0 ]; do
  if [[ $1 == *"--"* ]]; then
    if [[ $1 == *" "* ]]; then
      shift
      continue
    fi
    name="${1:2}"
    value="${2}"
    _FLAGMAP[${name}]=1
    if [[ $value != *"--"* ]] || [[ $value == *" "* ]] ; then
      _ARGMAP[${name}]="$value"
    else
      _ARGMAP[${name}]=""
    fi
  fi
  shift
done

function _argument() {
  if test "${_ARGMAP[${ARG_NAME}]+isset}" ; then
    echo ${_ARGMAP[${ARG_NAME}]}
  else
    if [ ${ARG_DEFAULT} -eq 0 ]; then
      echo "Error: required argument '--${ARG_NAME}' not specified" 1>&2
      exit 1
    else
      echo ${ARG_DEFAULT_VALUE}
    fi
  fi
}

function argument() {
  if [ $# -eq 1 ]; then
    ARG_NAME="$1" ARG_DEFAULT=0 ARG_DEFAULT_VALUE= _argument "${_ARGUMENT_DATA}"
  elif [ $# -eq 2 ]; then
    ARG_NAME="$1" ARG_DEFAULT=1 ARG_DEFAULT_VALUE="$2" _argument "${_ARGUMENT_DATA}"
  else
    echo "argument: invalid number of arguments" 1>&2
    return 1
  fi
  return 0
}

function flage() {
  if [ $# -eq 1 ]; then
    if [[ ${_FLAGMAP[$1]} ]] ; then
      echo "true"
      return 0
    elif [[ ${_FLAGMAP[no-$1]} ]] ; then
      echo "false"
      return 0
    else
      echo "true"
      return 0
    fi
  else
    echo "flag: invalid number of arguments" 1>&2
    return 1
  fi
}

function flagd() {
  if [ $# -eq 1 ]; then
    if [[ ${_FLAGMAP[$1]} ]] ; then
      echo "true"
      return 0
    elif [[ ${_FLAGMAP[no-$1]} ]] ; then
      echo "false"
      return 0
    else
      echo "false"
      return 0
    fi
  else
    echo "flag: invalid number of arguments" 1>&2
    return 1
  fi
}

function flag() {
  flagd $1
  return $?
}

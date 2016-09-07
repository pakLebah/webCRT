#!/bin/bash

# AUTOMATE FPC COMPILATION AND CGI APP DEPLOYMENT

splitPath() {
  local sp_dir= sp_fname= sp_bname= sp_ext=
  (( $# >= 2 )) || {
    echo "ERROR: Specify input path with an output variable name." >&2
    exit 2
  }
  sp_dir=$(dirname "$1")
  sp_fname=$(basename "$1")
  sp_ext=$([[ $sp_fname = *.* ]] && printf %s ".${sp_fname##*.}" || printf '')
  if [[ "$sp_fname" == "$sp_ext" ]]; then
    sp_bname=$sp_fname
    sp_ext=''
  else
    sp_bname=${sp_fname%$sp_ext}
  fi
  [[ -n $2 ]] && printf -v "$2" "$sp_dir"
  [[ -n $3 ]] && printf -v "$3" "$sp_fname"
  [[ -n $4 ]] && printf -v "$4" "$sp_bname"
  [[ -n $5 ]] && printf -v "$5" "$sp_ext"
  return 0
}

removeFile() {
  for f in "$@"; do
    if [ -f "$f" ]; then
      local CMD="rm $f"; echo "\$ $CMD"; eval $CMD;
    fi
  done
}

execCommand() {
  for f in "$@"; do
    local CMD="$f"; echo "\$ $CMD"; eval $CMD;
  done
}

# --- MAIN --- #

# argument check
if [ "$1" == "" ]; then
  echo "Usage: pas [main source file] <options>"
  echo "Options: "
  echo " -r    Run the executable file."
  echo "       <fpc args> Arguments to compiler."
  echo " -cgi  Deploy executable as CGI app."
  echo "       <CGI path> Path to CGI folder."
  echo " -web  Deploy executable as CGI app with source."
  echo "       <CGI path> Path to CGI folder."
  echo " other options are passed to the compiler."
  echo "_____"
  echo "ERROR: You must supply a source file as an argument."
  return 1
fi

# source file check
if [ ! -f "$1" ]; then
  echo "ERROR: \"$1\" source file is not found."
  return 1
fi

# extract file info
splitPath "$1" FDIR FFNAME FBNAME FEXT

# path constants (no double quotes)
uPath=~/pascal # default pascal repo
cgiPath=~/web  # default CGI folder on Koding

# pass unknown arguments to compiler
if [ "$2" == "-r" ] || [ "$2" == "-cgi" ] || [ "$2" == "-web" ]; then
  cArgs="$3 $4 $5 $6 $7 $8 $9"
else
  cArgs="$2 $3 $4 $5 $6 $7 $8"
fi

# compile code
echo "Compiling Pascal program..."
echo "=== 1. Compiling $FFNAME..."
execCommand "fpc -XXs -CX -O3 -S2achi $1 -Fu$uPath $cArgs"

# get compiler result
success=0 # as boolean (default false)
if [ -f $FDIR/$FBNAME ]; then success=1; fi # executable
if [ -f $FDIR/$FBNAME.ppu ]; then success=2; fi # unit

# run the produced executable file
if [ "$2" == "-r" ]; then
  echo "=== 2. Executing $FBNAME..."
  if [ $success == 1 ]; then
    execCommand "$FDIR/$FBNAME $3 $4 $5 $6 $7"
  elif [ $success == 2 ]; then
    echo "ERROR: Can't run unit file."
  else
    echo "ERROR: Compilation failed."
  fi
# deploy executable file as cgi app
elif [ "$2" == "-cgi" ]; then
  #if [ ! "$3" == "" ]; then cgiPath="$3"; fi
  echo "=== 2. Deploying $FBNAME to $cgiPath..."
  if [ $success == 1 ]; then
    execCommand "mv $FDIR/$FBNAME $cgiPath/$FBNAME.cgi"
  elif [ $success == 2 ]; then
    echo "ERROR: Can't deploy unit file."
  else
    echo "ERROR: Compilation failed."
  fi
# deploy executable file as web app with source
elif [ "$2" == "-web" ]; then
  #if [ ! "$3" == "" ]; then cgiPath="$3"; fi
  echo "=== 2. Deploying $FBNAME to $cgiPath..."
  if [ $success == 1 ]; then
    execCommand "mv $FDIR/$FBNAME $cgiPath/$FBNAME.cgi"
    execCommand "cp $FDIR/$FBNAME$FEXT $cgiPath"
  elif [ $success == 2 ]; then
    echo "ERROR: Can't deploy unit file."
  else
    echo "ERROR: Compilation failed."
  fi
fi

# clean up garbage files
if [ ! $success == 0 ]; then
  if [ "$2" == "-r" ] || [ "$2" == "-cgi" ] || [ "$2" == "-web" ]; then
    echo "=== 3. Cleaning up..."
    if [ "$2" == "-r" ]; then removeFile $FDIR/$FBNAME; fi
  else
    echo "=== 2. Cleaning up..."
  fi
  # remove main file junks
  removeFile $FDIR/$FBNAME.a
  removeFile $FDIR/$FBNAME.o
  removeFile $FDIR/$FBNAME.ppu
  removeFile $FDIR/libp$FBNAME.a
  # remove local unit file junks
  removeFile $FDIR/*.a
  removeFile $FDIR/*.o
  removeFile $FDIR/*.ppu
  removeFile $FDIR/libp*.a
  # remove additional files
  removeFile $uPath/*.a
  removeFile $uPath/*.o
  removeFile $uPath/*.ppu
  removeFile $uPath/libp*.a
fi

if [ $success == 0 ]; then 
  echo "Done with error!"
else
  echo "Done succesfully."
fi 

# to make things easy, put an alias to this
# script into your .bashrc file like this:
# alias pas=". ~/pas.sh"
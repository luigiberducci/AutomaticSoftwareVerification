#! /usr/bin/env bash

# Sylver Simulator Driver v 1.0
# 
# MIT License
# 
# Copyright (c) 2016 	Federico Mari <mari@di.uniroma1.it>
# 						Toni Mancini <tmancini@di.uniroma1.it>
# 						Annalisa Massini <massini@di.uniroma1.it>
# 						Igor Melatti <melatti@di.uniroma1.it>
# 						Enrico Tronci <tronci@di.uniroma1.it>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

MATLAB_DEFAULT=`which matlab`
OUTPUT_DEFAULT="output.txt"
DEBUG_DEFAULT="10"
T_DEFAULT="0.5"
k_DEFAULT="10"
s_DEFAULT="1"
S_DEFAULT="64"
l_DEFAULT="false"

USAGE="Usage: `basename $0` \t[-h]
              [-M MATLAB-path-to-executable]
              [-T simulator-sampling-time]
              [-k print-coverage-each-k-traces]
              [-s simulation-campaign-index]
              [-S simulation-campaigns-number]
              [-o logging-file]
              [-l]  (* Enables signal logging for debug. Slows down speed. *)
              [-d debugging-level]"

MATLAB=$MATLAB_DEFAULT
OUTPUT=$OUTPUT_DEFAULT
DEBUG=$DEBUG_DEFAULT
T=$T_DEFAULT
k=$k_DEFAULT
s=$s_DEFAULT
S=$S_DEFAULT
l=$l_DEFAULT

function print_options() {
  echo "MATLAB path to executable (-M arg). . . . . . .: $MATLAB"
  tps=`echo "1/$T" | bc`
  echo "Simulator sampling time (-T arg). . . . . . . .: $T (corresponding to TICKS_PER_SECOND=$tps in the disturbance model)"
  echo "Simulation campaign index (-s sim). . . . . . .: $s"
  echo "Simulation campaigns number (-S sim). . . . . .: $S"
  # echo "Simulation campaign file name (-s sim). . . . .: $SIMCAMPAIGN_FILE_NAME"
  # echo "Simulation campaign header file name (-S sim) .: $SIMCAMPAIGN_HEADER_FILE_NAME"
  echo "Logging file (-o arg) . . . . . . . . . . . . .: $OUTPUT"
  echo "Print coverage each arg traces (-k arg) . . . .: $k"
  echo "Signal logging enabled (-l) . . . . . . . . . .: $l"
  echo "Debugging level (-d arg). . . . . . . . . . . .: $DEBUG (0 nothing, 10 prints commands, 20 prints all)"
  echo
}

## Command line parsing
while getopts hlM:T:s:S:k:o:d: OPT; do
  case "$OPT" in
    h)
      echo ""
      echo -e $USAGE
      echo ""
      print_options
      exit 0
      ;;
    l)
      l="true"
      ;;
    M)
      MATLAB=$OPTARG
      ;;
    T)
      T=$OPTARG
      ;;
    s)
      s=$OPTARG
      ;;
    S)
      S=$OPTARG
      ;;
    k)
      k=$OPTARG
      ;;
    o)
      OUTPUT=$OPTARG
      ;;
    d)
      DEBUG=$OPTARG
      ;;
    \?)
      # getopts issues an error message
      echo -e $USAGE
      echo ""
      print_options
      echo ""
      exit 1
      ;;
  esac
done

if [ "$MATLAB" == "" ]
then
    echo Please install MATLAB
    exit
fi

SIMCAMPAIGN_FILE_NAME="simulation-campaigns/simCampaign_${s}_of_${S}.txt"
SIMCAMPAIGN_HEADER_FILE_NAME="simulation-campaigns/simCampaign_${s}_of_${S}.txt.header.txt"

if [ ! \( -f $SIMCAMPAIGN_FILE_NAME \) ]
then
    echo Wrong argument to option -s
    exit
fi

# execute simulator driver in background
$MATLAB -nodesktop -nosplash -nodisplay -logfile matlab.log -r "global sampling_time; global coverage_print_step; global debugging_level; global simcampaign_file_name; global simcampaign_header_file_name; global loggingOn; sampling_time = $T; coverage_print_step = $k; debugging_level = $DEBUG; simcampaign_file_name = '$SIMCAMPAIGN_FILE_NAME'; simcampaign_header_file_name = '$SIMCAMPAIGN_HEADER_FILE_NAME'; loggingOn=$l; run('$PWD/simulator_driver.m'); quit;" > $OUTPUT 2>&1

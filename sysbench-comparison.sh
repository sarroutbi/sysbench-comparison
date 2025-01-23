#!/bin/bash
# 
# Copyright (c) 2025 Sergio Arroutbi
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
#
REQ_TOOL=sysbench
REPORTS_DIR=reports

function err_exit {
  echo
  echo "$1"
  echo
  exit "$2"
}

function check_sysbench {
  type "${REQ_TOOL}" 2>/dev/null >/dev/null || err_exit "this scripts needs ${REQ_TOOL} tool" 1
}

function get_model_name {
  (grep 'model name' | awk -F ':' '{print $2}' | awk -F "@" '{print $1}' | sed -e 's@^ @@g' | sed -e 's@ CPU@@g' | head -1 | sed -e 's@ $@@g' | sed 's@[[:space:]]\+@.@g' | sed -e 's@\.$@@g' | sed -e 's@/@@g') < /proc/cpuinfo
}

function cpu_run {
  ${REQ_TOOL} cpu run > "${REPORTS_DIR}/$1-cpu-run.report"
}

check_sysbench
mkdir -p "${REPORTS_DIR}"

name="${1}"
test -z "${name}" && name=$(get_model_name)
cpu_run "${name}"


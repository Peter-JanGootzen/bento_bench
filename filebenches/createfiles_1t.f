#
# CDDL HEADER START
#
# The contents of this file are subject to the terms of the
# Common Development and Distribution License (the "License").
# You may not use this file except in compliance with the License.
#
# You can obtain a copy of the license at usr/src/OPENSOLARIS.LICENSE
# or http://www.opensolaris.org/os/licensing.
# See the License for the specific language governing permissions
# and limitations under the License.
#
# When distributing Covered Code, include this CDDL HEADER in each
# file and include the License file at usr/src/OPENSOLARIS.LICENSE.
# If applicable, add the following below this CDDL HEADER, with the
# fields enclosed by brackets "[]" replaced with your own identifying
# information: Portions Copyright [yyyy] [name of copyright owner]
#
# CDDL HEADER END
#
#
# Copyright 2008 Sun Microsystems, Inc.  All rights reserved.
# Use is subject to license terms.
#
# ident	"%Z%%M%	%I%	%E% SMI"

# Creates a fileset with 20,000 entries ($nfiles), but only preallocates
# 50% of the files.  Each file's size is set via a gamma distribution with
# a median size of 1KB ($filesize).
#
# The single thread then creates a new file and writes the whole file with
# 1MB I/Os.  The thread stops after 5000 files ($count/num of flowops) have
# been created and written to.

set $dir=/mnt/xv6fsll
set $count=1000000
set $filesize=1k
set $iosize=16k
set $meandirwidth=1000000
set $nfiles=800000
set $nthreads=20
set $fn=bigf

define fileset name=$fn,path=$dir,size=$filesize,entries=$nfiles,dirwidth=$meandirwidth,prealloc=50

define process name=filecreate,instances=1
{
  thread name=filecreatethread,memsize=10m,instances=$nthreads
  {
    flowop createfile name=createfile1,filesetname=$fn,fd=1
    flowop writewholefile name=writefile1,filesetname=$fn,fd=1,iosize=$iosize
    flowop closefile name=closefile1,fd=1
    flowop finishoncount name=finish,value=$count
  }
}

run 60

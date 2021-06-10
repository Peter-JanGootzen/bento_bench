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

# Single threaded asynchronous ($sync) sequential writes (1MB I/Os) to
# a 1GB file.
# Stops after 1 series of 1024 ($count) writes has been done.

set $dir=/mnt/xv6fsll
set $count=32000
set $iosize=128k
set $nthreads=20
set $sync=false
set $fn=seq_write_1t_128k

define file name=$fn,path=$dir,size=0,prealloc

define process name=filewriter,instances=1
{
  thread name=filewriterthread,memsize=10m,instances=$nthreads
  {
    flowop appendfile name=write-file,dsync=$sync,filename=$fn,iosize=$iosize,iters=$count
    flowop finishoncount name=finish,value=1
  }
}

run 60

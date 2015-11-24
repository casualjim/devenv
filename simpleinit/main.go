package main

/*
The MIT License (MIT)

Copyright (c) 2015 ramr

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

import (
	"fmt"
	"log"
	"os"
	"os/exec"
	"os/signal"
	"syscall"
)

// Mostly taken from: https://raw.githubusercontent.com/ramr/go-reaper
// but included here so it could be built outside the gopath

//  Handle death of child (SIGCHLD) messages. Pushes the signal onto the
//  notifications channel if there is a waiter.
func sigChildHandler(notifications chan os.Signal) {
	var sigs = make(chan os.Signal, 3)
	signal.Notify(sigs, syscall.SIGCHLD)

	for {
		var sig = <-sigs
		select {
		case notifications <- sig: /*  published it.  */
		default:
			/*
			 *  Notifications channel full - drop it to the
			 *  floor. This ensures we don't fill up the SIGCHLD
			 *  queue. The reaper just waits for any child
			 *  process (pid=-1), so we ain't loosing it!! ;^)
			 */
		}
	}

}

//  Be a good parent - clean up behind the children.
func reapChildren() {
	var notifications = make(chan os.Signal, 1)

	go sigChildHandler(notifications)

	for {
		var sig = <-notifications
		fmt.Printf(" - Received signal %v\n", sig)
		for {
			var wstatus syscall.WaitStatus

			/*
			 *  Reap 'em, so that zombies don't accumulate.
			 *  Plants vs. Zombies!!
			 */
			pid, err := syscall.Wait4(-1, &wstatus, 0, nil)
			for syscall.EINTR == err {
				pid, err = syscall.Wait4(-1, &wstatus, 0, nil)
			}

			if syscall.ECHILD == err {
				break
			}

			fmt.Printf(" - Grim reaper cleanup: pid=%d, wstatus=%+v\n",
				pid, wstatus)

		}
	}

}

/*
 *  ======================================================================
 *  Section: Exported functions
 *  ======================================================================
 */

//  Entry point for the reaper code. Start reaping children in the
//  background inside a goroutine.
func main() {
	/*
	 *  Only reap processes if we are taking over init's duties aka
	 *  we are running as pid 1 inside a docker container.
	 */
	if 1 == os.Getpid() {
		/*
		 *  Ok, we are the grandma of 'em all, so we get to play
		 *  the grim reaper.
		 *  You will be missed, Terry Pratchett!! RIP
		 */
		go reapChildren()
	}

	if fi, err := os.Stat("/etc/rc.local"); os.IsExist(err) {
		if !fi.IsDir() {
			cmd := exec.Command("/bin/sh", "/etc/rc.local")

			cmd.Stdout = os.Stdout
			cmd.Stderr = os.Stderr

			err := cmd.Start()
			if err != nil {
				log.Fatal(err)
			}

			err = cmd.Wait()
			if err != nil {
				log.Fatal(err)
			}
		}
	}

	blocker := make(chan struct{})
	<-blocker

}

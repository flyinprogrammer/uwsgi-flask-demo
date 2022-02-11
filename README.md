# uWSGI Flask Demo

So this is a tiny app, we use uWSGI to set it up.

In theory you can easily reproduce this on an M1 laptop:


1. Get yourself an M1 macbook/mini

2. Get yourself some [Rancher Desktop](https://rancherdesktop.io/)

3. Go get yourself some [buildx](https://docs.docker.com/buildx/working-with-buildx/)

4. [optionally] Go get yourself some [wrk](https://github.com/wg/wrk)

5. Run `make build-amd64`

```shell
github.com/flyinprogrammer/uwsgi-flask-demo via 🐍 v3.10.2 
❯ make build-amd64                 
docker buildx build --load --platform linux/amd64 -t flyinprogrammer/uwsgi-flask-demo:amd64 .
[+] Building 73.0s (10/10) FINISHED
=> [internal] load build definition from Dockerfile 0.0s
=> => transferring dockerfile: 176B 0.0s
=> [internal] load .dockerignore 0.0s
=> => transferring context: 3.84kB 0.0s
=> [internal] load metadata for docker.io/library/python:3.9 0.0s
=> [1/5] FROM docker.io/library/python:3.9 0.0s
=> [internal] load build context 0.0s
=> => transferring context: 5.77kB 0.0s
=> [2/5] WORKDIR /opt/app 0.0s
=> [3/5] COPY requirements.txt . 0.0s
=> [4/5] RUN pip install -r requirements.txt 72.8s
=> [5/5] COPY . . 0.0s
=> exporting to image 0.1s
=> => exporting layers 0.1s
=> => writing image sha256:cfdbd6edb293b1754343b8b660fe8d4c2244c1eeb5f2b5e363a72c92ead1a013 0.0s 
=> => naming to docker.io/flyinprogrammer/uwsgi-flask-demo:amd64  0.0s 

```

6. Run `make run-amd64`

7. Watch the logs show socket 0 are full because something is sad.

```shell
github.com/flyinprogrammer/uwsgi-flask-demo via 🐍 v3.10.2 took 1m13s 
❯ make run-amd64
docker run --platform linux/amd64 --rm -it -p 8080:8080 -p 8081:8081 flyinprogrammer/uwsgi-flask-demo:amd64
========== START UWSGI CONFIG ==========
[uwsgi]
disable-logging = true
http = :8080
module = app:app

stats-http = true
stats-server = 0.0.0.0:8081

master = true
processes = 4
single-interpreter = true
enable-threads = true
threads = 2
thunder-lock = true

uid = nobody
========== END UWSGI CONFIG ==========
[uWSGI] getting INI configuration from ./uwsgi.ini
*** Starting uWSGI 2.0.20 (64bit) on [Fri Feb 11 17:24:00 2022] ***
compiled with version: 10.2.1 20210110 on 11 February 2022 17:01:55
os: Linux-5.10.93-0-virt #1-Alpine SMP Thu, 27 Jan 2022 09:34:38 +0000
nodename: 69c8157b72b2
machine: x86_64
clock source: unix
pcre jit disabled
detected number of CPU cores: 6
current working directory: /opt/app
detected binary path: /usr/local/bin/uwsgi
setuid() to 65534
your memory page size is 4096 bytes
detected max file descriptor number: 1048576
lock engine: pthread robust mutexes
!!! it looks like your kernel does not support pthread robust mutexes !!!
!!! falling back to standard pthread mutexes !!!
thunder lock: enabled
uWSGI http bound on :8080 fd 4
uwsgi socket 0 bound to TCP address 127.0.0.1:40447 (port auto-assigned) fd 3
Python version: 3.9.10 (main, Feb  8 2022, 05:06:38)  [GCC 10.2.1 20210110]
Python main interpreter initialized at 0x4000172cb0
python threads support enabled
your server socket listen backlog is limited to 100 connections
your mercy for graceful operations on workers is 60 seconds
mapped 416880 bytes (407 KB) for 8 cores
*** Operational MODE: preforking+threaded ***
WSGI app 0 (mountpoint='') ready in 1 seconds on interpreter 0x4000172cb0 pid: 10 (default app)
spawned uWSGI master process (pid: 10)
spawned uWSGI worker 1 (pid: 17, cores: 2)
spawned uWSGI worker 2 (pid: 19, cores: 2)
spawned uWSGI worker 3 (pid: 21, cores: 2)
spawned uWSGI worker 4 (pid: 22, cores: 2)
*** Stats server enabled on 0.0.0.0:8081 fd: 18 ***
spawned uWSGI http 1 (pid: 25)
Fri Feb 11 17:24:02 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
Fri Feb 11 17:24:03 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
Fri Feb 11 17:24:04 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
Fri Feb 11 17:24:05 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
Fri Feb 11 17:24:06 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
^CSIGINT/SIGTERM received...killing workers...
gateway "uWSGI http 1" has been buried (pid: 25)
Fri Feb 11 17:24:07 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
Fri Feb 11 17:24:08 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
worker 1 buried after 1 seconds
worker 2 buried after 1 seconds
[deadlock-detector] pid 21 was holding lock thunder (0x40045a5000)
worker 3 buried after 1 seconds
worker 4 buried after 1 seconds
goodbye to uWSGI.
make: *** [run-amd64] Error 130
```

This is the sad:

```text
Fri Feb 11 17:24:08 2022 - *** uWSGI listen queue of socket "127.0.0.1:40447" (fd: 3) full !!! (74256320/64) ***
```

Who is hurting our little socket?

8. Watch this problem go away with:

```shell
make build-arm64
make run-arm64
```

* Be confused and amazed anything in this world works.
* Schedule time to have an exetentional crisis about "What is a thread?".

9. Iterate on combinations of configurations because you're a monkey and curious.
Then establish a crude pattern that the issue seems to be related to something about
the `master = true` and that the stats server requires `master = true` to spawn. Also
no combination of `processes` and `threads` seemed to have any impact this.

10. Get your hands on a _real_ linux computer because life is spectacular these day.
Then run a public version of this image, and notice the error only exists on top
of the qemu emulation bits. :shrug:

```shell
docker run --init --rm -it -p 8080:8080 -p 8081:8081 flyinprogrammer/uwsgi-flask-demo:amd64
```

11. Look for friends on The Internet to help because I am dumb and perhaps they have
some easy answers rather than loosing my life to figuring how to debug this with
gdb or something. :shrug:


# Notes

## Docker Tags

I know Docker and other CLI tools don't require architecture as part of the tags, it just
seemed to make things easier when testing locally. It also seems impossible to inspect
architecture at runtime other than `docker top <conainer name>` and see `/usr/bin/qemu-x86_64`
in front of all your processes :sparkles: magic :sparkles:.

## wrk

I optionally install and used wrk to figure out if maybe adding load would help or hurt things.
So far it seems like there's nothing to write home about other than, "qemu is slow" which
is hilarious because "qemu" is actually the 8th Wonder in the world.

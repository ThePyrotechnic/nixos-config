#!/usr/bin/env python

import signal
import time


SIGNALED = False


def handler(signum, frame):
    global SIGNALED

    if signum == signal.SIGINT:
        SIGNALED = True


def main():
    start = time.time()
    while not SIGNALED:
        print(time.time() - start, end="\r")
    print(time.time() - start)


if __name__ == "__main__":
    signal.signal(signal.SIGINT, handler)
    main()


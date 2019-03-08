#!/bin/sh -e

 # Run browser in GUI with VNC server.
if [ "$DEBUG" ]; then
    # Ensure firefox launches on the correct DISPLAY.
    export DISPLAY=:99

    Xvfb $DISPLAY -screen 0 '1920x1080x24' &

    for i in `seq 1 10`
    do
        if xdpyinfo -display $DISPLAY >/dev/null 2>&1; then
            break
        elif [ $i -eq 10 ]; then
            echo "Xvfb failed to start in time..."
            exit 1
        fi
        echo "Waiting for Xvfb..."
        sleep 1
    done

    fluxbox -display $DISPLAY &

    # HACK Password setup is required otherwise Mac OS X Screen Sharing hangs on connect.
    mkdir -p ~/.x11vnc
    x11vnc -storepasswd letmein ~/.x11vnc/passwd

    # Run VNC backgrounded.
    x11vnc -bg -forever -shared -rfbport 5901 -rfbauth ~/.x11vnc/passwd -display $DISPLAY

    taf "$@"
elif [ $1 = "Security-Audit" ]; then
    bundle audit check --update
else
    taf "$@"
fi
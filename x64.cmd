docker buildx build --platform=linux/amd64 --progress=plain --output type=local,dest=build/x64 .
docker run --rm --privileged -v x:\workspaces\bubblewrap\build\x64\bubblewrap.tar.gz:/bubblewrap.tar.gz alpine sh -c "apk add -q libcap setpriv && tar xzf /bubblewrap.tar.gz && /usr/bin/bwrap --cap-drop ALL --cap-add CAP_SYSLOG --bind / / --uid 1000 --gid 1234 setpriv -d"

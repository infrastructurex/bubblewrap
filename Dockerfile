FROM alpine:3.18.0 AS build

ARG ARCH
ENV ARCH=$ARCH
ARG TAG
ENV TAG=$TAG

RUN apk add wget make gcc musl-dev linux-headers libcap-dev patch
ADD build.sh /build/build.sh
ADD root_uid_gid.patch /build
RUN /build/build.sh


FROM scratch AS export
COPY --from=build /bubblewrap.tar.gz .

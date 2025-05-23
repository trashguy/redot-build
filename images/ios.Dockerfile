ARG source_image
ARG osx_image
FROM ${source_image} as files

ADD files /root/files

FROM ${osx_image}

ENV IOS_SDK=18.2

COPY --from=files /root/files/  /root/files/

RUN dnf -y install --setopt=install_weak_deps=False \
      automake autoconf gcc gcc-c++ gcc-objc gcc-objc++ cmake libicu-devel libtool libxml2-devel openssl-devel perl python yasm

RUN git clone --progress https://github.com/tpoechtrager/cctools-port && \
    cd /root/cctools-port && \
    git checkout 81f205e8ca6bbf2fdbcb6948132454fd1f97839e && \
    # arm64 device
    usage_examples/ios_toolchain/build.sh /root/files/iPhoneOS${IOS_SDK}.sdk.tar.xz arm64 && \
    mkdir -p /root/ioscross/arm64 && \
    mv usage_examples/ios_toolchain/target/* /root/ioscross/arm64 && \
    mkdir /root/ioscross/arm64/usr && \
    ln -s /root/ioscross/arm64/bin /root/ioscross/arm64/usr/bin && \
    # Prepare for simulator builds
    sed -i '/WRAPPER_SDKDIR/s/iPhoneOS/iPhoneSimulator/' usage_examples/ios_toolchain/build.sh && \
    # arm64 simulator
    usage_examples/ios_toolchain/build.sh /root/files/iPhoneSimulator${IOS_SDK}.sdk.tar.xz arm64 && \
    mkdir -p /root/ioscross/arm64_sim && \
    mv usage_examples/ios_toolchain/target/* /root/ioscross/arm64_sim && \
    mkdir /root/ioscross/arm64_sim/usr && \
    ln -s /root/ioscross/arm64_sim/bin /root/ioscross/arm64_sim/usr/bin && \
    # x86_64 simulator
    sed -i 's/^TRIPLE=.*/TRIPLE="x86_64-apple-darwin11"/' usage_examples/ios_toolchain/build.sh && \
    usage_examples/ios_toolchain/build.sh /root/files/iPhoneSimulator${IOS_SDK}.sdk.tar.xz x86_64 && \
    mkdir -p /root/ioscross/x86_64_sim && \
    mv usage_examples/ios_toolchain/target/* /root/ioscross/x86_64_sim && \
    mkdir /root/ioscross/x86_64_sim/usr && \
    ln -s /root/ioscross/x86_64_sim/bin /root/ioscross/x86_64_sim/usr/bin && \
    cd /root && \
    rm -rf /root/cctools-port && \
    rm -rf /root/files

ENV OSXCROSS_IOS=not_nothing
ENV IOSCROSS_ROOT=/root/ioscross
ENV PATH="/root/ioscross/arm64/bin:/root/ioscross/arm64_sim/bin:/root/ioscross/x86_64_sim/bin:${PATH}"

CMD /bin/bash

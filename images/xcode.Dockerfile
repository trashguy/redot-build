ARG source_image
FROM ${source_image} as files

ADD files /root/files

FROM ${source_image}

RUN dnf -y install --setopt=install_weak_deps=False \
      clang xar xar-devel xz-devel cpio && \
    git clone --progress https://github.com/nrosenstein-stuff/pbzx && \
    cd pbzx && \
    git checkout bf536e167f2e514866f91d7baa0df1dff5a13711 && \
    clang -O3 -llzma -lxar -I /usr/local/include pbzx.c -o pbzx

ENV XCODE_SDKV=
ENV OSX_SDKV=
ENV IOS_SDKV=

COPY --from=files /root/files/  /root/files/

CMD mkdir -p /root/xcode && \
    cd /root/xcode && \
    xar -xf /root/files/Xcode_${XCODE_SDKV}.xip && \
    /root/pbzx/pbzx -n Content | cpio -i && \
    export OSX_SDK=MacOSX${OSX_SDKV}.sdk && \
    cp -r Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX.sdk /tmp/${OSX_SDK} && \
    cd /tmp && \
    tar -cJf /root/files/${OSX_SDK}.tar.xz ${OSX_SDK} && \
    rm -rf ${OSX_SDK} && \
    cd /root/xcode && \
    export IOS_SDK=iPhoneOS${IOS_SDKV}.sdk && \
    export IOS_SIMULATOR_SDK=iPhoneSimulator${IOS_SDKV}.sdk && \
    cp -r Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Developer/SDKs/iPhoneOS.sdk /tmp/${IOS_SDK} && \
    cd /tmp && \
    tar -cJf /root/files/${IOS_SDK}.tar.xz ${IOS_SDK} && \
    rm -rf ${IOS_SDK} && \
    cd /root/xcode && \
    cp -r Xcode.app/Contents/Developer/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk /tmp/${IOS_SIMULATOR_SDK} && \
    cd /tmp && \
    tar -cJf /root/files/${IOS_SIMULATOR_SDK}.tar.xz ${IOS_SIMULATOR_SDK} && \
    rm -rf ${IOS_SIMULATOR_SDK}


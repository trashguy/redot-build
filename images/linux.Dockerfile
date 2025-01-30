ARG source_image
FROM ${source_image}

ENV GODOT_SDK_LINUX_X86_64=/root/x86_64-godot-linux-gnu_sdk-buildroot
ENV GODOT_SDK_LINUX_X86_32=/root/i686-godot-linux-gnu_sdk-buildroot
ENV GODOT_SDK_LINUX_ARM64=/root/aarch64-godot-linux-gnu_sdk-buildroot
ENV GODOT_SDK_LINUX_ARM32=/root/arm-godot-linux-gnueabihf_sdk-buildroot
ENV BASE_PATH=${PATH}

RUN dnf install -y wayland-devel && \
    curl -LO https://github.com/godotengine/buildroot/releases/download/godot-2023.08.x-4/x86_64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    tar xf x86_64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    rm -f x86_64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    cd x86_64-godot-linux-gnu_sdk-buildroot && \
    ./relocate-sdk.sh && \
    cd /root && \
    curl -LO https://github.com/godotengine/buildroot/releases/download/godot-2023.08.x-4/i686-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    tar xf i686-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    rm -f i686-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    cd i686-godot-linux-gnu_sdk-buildroot && \
    ./relocate-sdk.sh && \
    cd /root && \
    curl -LO https://github.com/godotengine/buildroot/releases/download/godot-2023.08.x-4/aarch64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    tar xf aarch64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    rm -f aarch64-godot-linux-gnu_sdk-buildroot.tar.bz2 && \
    cd aarch64-godot-linux-gnu_sdk-buildroot && \
    ./relocate-sdk.sh && \
    cd /root && \
    curl -LO https://github.com/godotengine/buildroot/releases/download/godot-2023.08.x-4/arm-godot-linux-gnueabihf_sdk-buildroot.tar.bz2 && \
    tar xf arm-godot-linux-gnueabihf_sdk-buildroot.tar.bz2 && \
    rm -f arm-godot-linux-gnueabihf_sdk-buildroot.tar.bz2 && \
    cd arm-godot-linux-gnueabihf_sdk-buildroot && \
    ./relocate-sdk.sh

CMD /bin/bash

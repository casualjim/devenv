FROM scratch

MAINTAINER "Ivan Porto Carrero <ivan@flanders.co.nz>"

ADD ./arch-mini-bootstrap_2015-12-29.tar.xz /
ADD files/mirrorlist /etc/pacman.d/
ADD files/locale.conf files/pacman.conf /etc/
RUN chown 'root:root' /etc/{pacman.d/mirrorlist,locale.conf,pacman.conf} && \
    chmod 'u=rwX,g=rX,o=rX' /etc/{pacman.d/mirrorlist,locale.conf,pacman.conf}

RUN \
    ln --symbolic /usr/share/zoneinfo/UTC /etc/localtime && \
    localedef --inputfile=en_US --charmap=UTF-8 en_US.UTF-8 && \
    pacman-key --init && \
    pacman-key --populate archlinux && \
    pacman --sync --noconfirm --refresh --sysupgrade && \
    find /var/cache/pacman/pkg -mindepth 1 -delete

CMD ["/bin/bash"]

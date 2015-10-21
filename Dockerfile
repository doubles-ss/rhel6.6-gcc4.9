FROM rhel6.6

MAINTAINER Suriya Soutmun <deu@odd-e.co.th>

ENV GCC_VER 4.9.2

ADD centos.repo /etc/yum.repos.d/

RUN yum install -y  wget tar bzip2 gzip gcc openssh-server && \
    yum groupinstall -y 'Development Tools' && \
    wget -O /root/gcc-${GCC_VER}.tar.bz2  https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2 && \
    cd /root && tar xvjf gcc-${GCC_VER}.tar.bz2  && \
    cd /root/gcc-${GCC_VER} && contrib/download_prerequisites && \
    mkdir -p /root/gcc-${GCC_VER}/build && cd /root/gcc-${GCC_VER}/build && \
    ../configure --prefix=/usr/local/gcc --disable-bootstrap --enable-shared --enable-threads=posix --with-system-zlib --enable-languages=c,c++,go --build=x86_64-redhat-linux --disable-multilib
    yum install -y zlib-devel && \
    make -j8 && \
    make install && \
    yum clean all && \
    rm -rf /root/* && \
    ln -s /usr/local/gcc/bin/gcc /usr/bin/ && \
    ln -s /usr/local/gcc/bin/g++ /usr/bin/ && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    echo 'root:$And@ais;' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

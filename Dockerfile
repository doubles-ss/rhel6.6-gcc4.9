FROM rhel6.6
MAINTAINER Suriya Soutmun <deu@odd-e.co.th>
ADD centos.repo /etc/yum.repos.d/
RUN yum install -y  wget tar bzip2 gzip gcc
RUN yum groupinstall -y 'Development Tools'

ENV GCC_VER 4.9.2

RUN wget -O /root/gcc-${GCC_VER}.tar.bz2  https://ftp.gnu.org/gnu/gcc/gcc-${GCC_VER}/gcc-${GCC_VER}.tar.bz2
RUN cd /root && tar xvjf gcc-${GCC_VER}.tar.bz2 
RUN cd /root/gcc-${GCC_VER} && contrib/download_prerequisites 

RUN mkdir -p /root/gcc-${GCC_VER}/build && cd /root/gcc-${GCC_VER}/build
RUN ../configure --prefix=/usr/local/gcc --disable-bootstrap --enable-shared --enable-threads=posix --with-system-zlib --enable-languages=c,c++,go --build=x86_64-redhat-linux --disable-multilib
RUN make -j8 && \
    make install
RUN yum remove -y gcc && \
    rm -rf /root/* && \
    ln -s /usr/local/gcc/bin/* /usr/bin/
RUN ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    echo 'root:$And@ais;' | chpasswd

EXPOSE 22

CMD ["/usr/sbin/sshd","-D"]

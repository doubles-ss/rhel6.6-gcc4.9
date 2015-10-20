FROM rhel6.6
MAINTAINER Suriya Soutmun <deu@odd-e.co.th>

ADD *.repo /etc/yum.repos.d/
RUN yum install -y  wget tar bzip2 gzip gcc && \
    yum groupinstall -y 'Development Tools' && \
    wget -O /root/gcc-4.9.2.tar.bz2  https://ftp.gnu.org/gnu/gcc/gcc-4.9.2/gcc-4.9.2.tar.bz2 && \
    cd /root && tar xvjf gcc-4.9.2.tar.bz2 && \
    cd /root/gcc-4.9.2 && contrib/download_prerequisites && \
    mkdir -p /root/gcc-4.9.2/build && cd /root/gcc-4.9.2/build && \
    ../configure --prefix=/usr/local/gcc-4.9.2 --program-suffix -4.9 --disable-bootstrap --enable-shared --enable-threads=posix --with-system-zlib --enable-languages=c,c++,go --build=x86_64-redhat-linux --disable-multilib && \
    make -j8 && \
    make install  && \
    yum remove -y gcc && \
    rm -rf /root/* && \
    ln -s /usr/local/gcc-4.9.2/bin/* /usr/bin/ && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    echo 'root:$And@ais;' | chpasswd

CMD ["/usr/sbin/sshd","-D"]

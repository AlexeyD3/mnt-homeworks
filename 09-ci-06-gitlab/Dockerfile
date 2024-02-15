FROM centos:8
#fix centos stream repo
RUN cd /etc/yum.repos.d/
RUN sed -i 's/mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-*
RUN sed -i 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/CentOS-*
#install python from source code
ENV VERSION=3.8.18
RUN yum -y install epel-release
RUN yum update -y
RUN yum -y groupinstall "Development Tools"
RUN yum -y install openssl-devel bzip2-devel libffi-devel xz-devel
RUN yum -y install wget
RUN wget https://www.python.org/ftp/python/$VERSION/Python-$VERSION.tgz
RUN tar xf Python-$VERSION.tgz
RUN rm Python-$VERSION.tgz
CMD Python-$VERSION/
RUN chmod +x /Python-$VERSION/configure
RUN /Python-$VERSION/configure --enable-optimizations
RUN make altinstall
RUN python3.8 --version
RUN pip3.8 --version
#copy app and requirements
COPY requirements.txt .
RUN pip3.8 install --no-cache-dir -r requirements.txt
COPY app.py /python_api/app.py
WORKDIR /python_api
CMD ["python3.8", "/python_api/app.py"]

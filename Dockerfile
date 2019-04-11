#依赖的镜像
FROM centos:centos7
#镜像创建者的信息
LABEL maintainer="Terwer Green <cbgtyw@gmail.com>"

### Envrionment config
ENV TZ=Asia/Shanghai \
    TZ=CST-8 \
    USER=terwer

# 添加网易源
RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
    && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.163.com/.help/CentOS7-Base-163.repo \
    && yum clean all \
    && yum makecache \
    && yum update -y \
    && yum upgrade -y \
&& echo "mirror set finished."

# 创建用户
# Install various packages to get compile environment
# "MATE Desktop" is an environment group which should only be used for initial system installation. "MATE", or "mate-desktop", is the desktop group that should be used to install the desktop on an installed system.
# see https://bugzilla.redhat.com/show_bug.cgi?id=1579397
RUN yum install epel-release -y \
    && yum groupinstall "Server with GUI" -y \
    && yum install tigervnc-server -y

# 容器入口
COPY ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["bash", "/entrypoint.sh"]
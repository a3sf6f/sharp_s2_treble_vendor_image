# requires --privileged parameter to docker-run,
# to mount/umount an image.
FROM ubuntu:bionic

RUN apt update && apt install -y \
	android-tools-fsutils \
	make \
	sudo \
	git \
	libcap2-bin

RUN useradd packer \
	&& echo "packer:packer" | chpasswd \
	&& adduser packer sudo \
	&& echo "packer ALL=NOPASSWD: ALL" >> /etc/sudoers

WORKDIR /vendor

RUN chown packer:packer /vendor

COPY --chown=packer:packer . /vendor

USER packer

CMD ["make", "test"]

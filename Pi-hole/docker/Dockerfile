FROM pihole/pihole:latest

COPY unbound.sh unbound.sh

RUN apt update --assume-yes; \
  ./unbound.sh && \
  rm --recursive --force unbound.sh
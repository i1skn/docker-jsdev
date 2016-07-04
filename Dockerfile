FROM debian:latest

RUN apt-get update && apt-get install curl git-core --assume-yes && apt-get clean
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.2/install.sh | bash

ADD run.sh /run.sh
RUN chmod +x /run.sh

CMD ["/run.sh"]

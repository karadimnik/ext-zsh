# FROM node:12-alpine
# RUN apk add --no-cache python2 g++ make
# WORKDIR /app
# COPY . .
# RUN yarn install --production
# CMD ["node", "src/index.js"]

FROM ubuntu:20.04
# RUN apt add --no-cache bash
# RUN apk add --no-cache sudo
# RUN apk add --no-cache ncurses

RUN apt-get update  
RUN apt-get install -y locales  
RUN localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
RUN apt-get install -y curl
RUN apt-get install -y git

ENV LANG en_US.utf8
 
COPY lib.sh .
COPY setup-zsh.sh .
COPY setup-zsh_functions.sh .
RUN chmod u+x lib.sh
RUN chmod u+x setup-zsh.sh
RUN chmod u+x setup-zsh_functions.sh
RUN ./setup-zsh.sh TRUE
RUN exec zsh
ENTRYPOINT [ "/usr/bin/zsh" ]
# ENTRYPOINT [ "./setup-zsh.sh" ]
# CMD ["bash"]
FROM ruby:2.5

RUN apt-get update -qq && apt-get install -y apt-transport-https

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - 
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN curl -sL https://deb.nodesource.com/setup_9.x | bash -
RUN apt-get update -qq && apt-get install -y apt-transport-https build-essential libpq-dev nodejs libappindicator1 fonts-liberation \
    libasound2 libgconf-2-4 libgtk-3-0 libnspr4 libnss3 libx11-xcb1 libxss1 libxtst6 lsb-release xdg-utils yarn

RUN  curl -O https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && \
     dpkg -i google-chrome-stable_current_amd64.deb

RUN mkdir /myapp
WORKDIR /myapp
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD package.json /myapp/package.json
ADD yarn.lock /myapp/yarn.lock
RUN yarn install
ENTRYPOINT ["bundle", "exec", "rails"]
CMD ["server", "-b", "0.0.0.0"]

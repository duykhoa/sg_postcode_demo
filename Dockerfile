FROM phusion/passenger-ruby22
ENV HOME /home/app
ENV SECRET_KEY_BASE `rake secret`
CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD webapp.conf /etc/nginx/sites-enabled/webapp.conf
RUN rm -f /etc/service/redis/down

RUN mkdir /home/app/webapp
WORKDIR /home/app/webapp
RUN chown -R app:app /home/app/webapp

ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN sudo -u app bundle install --deployment

ADD . /home/app/webapp
RUN chown -R app:app /home/app/webapp

RUN RAILS_ENV=production rake assets:precompile

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

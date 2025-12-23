FROM jekyll/jekyll:latest

WORKDIR /srv/jekyll

# Gemfile만 먼저 복사하고 의존성 설치
COPY Gemfile ./
RUN rm -rf Gemfile.lock && bundle install

# 나머지 파일 복사
COPY . /srv/jekyll

EXPOSE 4000
EXPOSE 35729

# entrypoint 스크립트 생성
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'rm -f Gemfile.lock' >> /entrypoint.sh && \
    echo 'bundle install' >> /entrypoint.sh && \
    echo 'gem uninstall -aIx sass-embedded 2>/dev/null || true' >> /entrypoint.sh && \
    echo 'gem install sass-embedded' >> /entrypoint.sh && \
    echo 'exec "$@"' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jekyll", "serve", "--livereload", "--host", "0.0.0.0", "--port", "4000", "--future"]

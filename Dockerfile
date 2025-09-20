FROM ruby:3.2.5
ENV APP /app
ENV LANG C.UTF-8
ENV TZ Asia/Tokyo

# Node.js リポジトリ登録＋ビルドツール＋PostgreSQLクライアント導入
RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - \
 && apt update -qq \
 && apt install -y build-essential postgresql-client nodejs \
 && npm install --global yarn

WORKDIR $APP

# まずは Gemfile だけコピーして bundle install（キャッシュ活用）
COPY Gemfile* $APP/

# bundle install を実行
RUN bundle install

# アプリケーションファイルをコピー
COPY . $APP/

# ポート3000を公開
EXPOSE 3000

# サーバー起動コマンド
CMD ["bin/rails", "server", "-b", "0.0.0.0"]

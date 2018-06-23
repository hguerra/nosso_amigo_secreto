FROM ruby:2.5.1

# add nodejs and yarn dependencies for the frontend
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

# Instala nossas dependencias
RUN apt-get update && apt-get install -qq -y --no-install-recommends nodejs yarn build-essential libpq-dev imagemagick git-all nano

# Seta nosso path
ENV INSTALL_PATH /nosso_amigo_secreto


# Cria nosso diretório
RUN mkdir -p $INSTALL_PATH


# Seta o nosso path como o diretório principal
WORKDIR $INSTALL_PATH


# Copia o nosso Gemfile para dentro do container
COPY Gemfile ./


# Seta o path para as Gems
ENV BUNDLE_PATH /box


# Copia nosso código para dentro do container
COPY . .
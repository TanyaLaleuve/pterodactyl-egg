# On utilise une base légère (Alpine ou Debian Slim)
FROM eclipse-temurin:21-jdk-jammy

# Mise à jour et installation des dépendances
# AJOUT : bc et sed sont indispensables pour ton nouveau script
RUN apt-get update -y \
    && apt-get install -y lsof curl ca-certificates openssl git tar sqlite3 fontconfig libfreetype6 tzdata iproute2 libstdc++6 bc sed \
    && useradd -d /home/container -m container

# Configuration de l'utilisateur Pterodactyl
USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

# Copie du script d'entrée
COPY ./entrypoint.sh /entrypoint.sh

# Commande de lancement
CMD ["/bin/bash", "/entrypoint.sh"]
@echo off
set USER=tanyalaleuve

echo ============================================
echo Mise a jour des images Docker Pterodactyl
echo ============================================

echo Mise a jour Java 8...
copy /Y entrypoint.sh java8\entrypoint.sh
cd java8 && docker build --no-cache -t %USER%/pterodactyl-java:8 . && docker push %USER%/pterodactyl-java:8 && cd ..

echo Mise a jour Java 11...
copy /Y entrypoint.sh java11\entrypoint.sh
cd java11 && docker build --no-cache -t %USER%/pterodactyl-java:11 . && docker push %USER%/pterodactyl-java:11 && cd ..

echo Mise a jour Java 21...
copy /Y entrypoint.sh java21\entrypoint.sh
cd java21 && docker build --no-cache -t %USER%/pterodactyl-java:21 . && docker push %USER%/pterodactyl-java:21 && cd ..

echo Mise a jour Java 25...
copy /Y entrypoint.sh java25\entrypoint.sh
cd java25 && docker build --no-cache -t %USER%/pterodactyl-java:25 . && docker push %USER%/pterodactyl-java:25 && cd ..

echo.
echo ============================================
echo Termine ! Tes 4 images sont a jour.
echo ============================================
pause
#!/bin/bash
cd /home/container
# ============================================
# Header Tanya Minimalist
# ============================================
echo -e "\033[1;35m--------------------------------------------"
echo -e "\033[1;36m   Tanya Pterodactyl - Java Edition"
echo -e "\033[1;35m--------------------------------------------\033[0m"
echo -e "\033[1;33m Runtime :\033[0m $(java -version 2>&1 | head -n 1)"
echo ""
# 1. Calcul de la RAM (95% de SERVER_MEMORY)
if [ -z "${SERVER_MEMORY}" ]; then
    XMX_SIZE="1024"
else
    # Utilisation de 'bc' pour le calcul précis
    XMX_SIZE=$(echo "(${SERVER_MEMORY} * 0.95) / 1" | bc 2>/dev/null || echo "${SERVER_MEMORY}")
fi

echo -e "\033[1;34m[Memory] Allocation de ${XMX_SIZE}MB (95% de ${SERVER_MEMORY}MB)\033[0m"

# 2. Définition des flags Aikar
AIKAR_FLAGS="-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1"

# 3. Préparation des flags à ajouter
FLAGS_TO_ADD=""
if [ "${OPTIMIZED_FLAGS}" == "1" ]; then
    FLAGS_TO_ADD="${AIKAR_FLAGS}"
    echo -e "\033[1;32m[Info] Optimisations activées.\033[0m"
fi

# 4. Nettoyage de la commande de démarrage
# On remplace {{SERVER_MEMORY}} par notre calcul et on convertit le format Ptero en format Bash
# On utilise des pipes | dans sed pour éviter les conflits avec d'éventuels slashs /
TEMP_STARTUP=$(echo -e ${STARTUP} | sed -e "s|{{SERVER_MEMORY}}|${XMX_SIZE}|g" -e 's|{{|$|g' -e 's|}}||g')

# 5. Injection INTELLIGENTE des flags
# On retire le mot "java" du début s'il existe pour le remettre proprement avec les flags
# Cela évite les doublons si l'utilisateur l'a déjà mis
RAW_COMMAND=$(echo "${TEMP_STARTUP}" | sed 's/^java//g')
FINAL_COMMAND="java ${FLAGS_TO_ADD} ${RAW_COMMAND}"

# 6. Lancement
echo -e "\033[1;33m[Lancement] ${FINAL_COMMAND}\033[0m"

sleep 1.5
echo "App starting!"
# On envoie le signal pour forcer le passage au VERT instantanément
echo "App started!"

# On demande à bash d'interpréter la ligne avant de l'exécuter
FINAL_COMMAND=$(eval echo "${FINAL_COMMAND}")
exec ${FINAL_COMMAND}
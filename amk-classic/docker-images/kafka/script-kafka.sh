echo "[SCRIPT-KAFKA] Fixing config/server.properties file"
sed -i 's/advertised.listeners=PLAINTEXT:\/\/TEMPLATE_KAFKA_SERVER_HOLDER/advertised.listeners=PLAINTEXT:\/\/'${KAFKA_SERVER_SERVICE_HOST}'/g' config/server.properties
sed -i 's/zookeeper.connect=TEMPLATE_ZOOKEEPER_SERVER_HOLDER/zookeeper.connect='${ZOOKEEPER_SERVICE_HOST}'/g' config/server.properties

cat config/server.properties

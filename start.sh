if [[ -z "${ALLOW_HEADERS}" ]]; then
    echo "You can config ALLOW_HEADERS"
else
    ALLOW_HEADERS="${ALLOW_HEADERS//,/\\,}"
    sed -i -e "s,___ALLOW_HEADERS___,$ALLOW_HEADERS,ig" /etc/nginx/conf.d/default.conf;
fi

if [[ -z "${TARGET_HOST}" ]]; then
    echo "Miss TARGET_HOST environment"
    exit 1
else 
    echo "Adding $TARGET_HOST to the NGINX config";
    sed -i -e "s,___TARGET_HOST___,$TARGET_HOST,ig" /etc/nginx/conf.d/default.conf;
fi

if [[ ! -z "${WS_ONLY}" ]]; then
    echo "Set Upgrade to \"WebSocket\"";
    sed -i -e "s,Upgrade\ \$http_upgrade,Upgrade\ \"WebSocket\",ig" /etc/nginx/conf.d/default.conf;
    
    echo "Set Connection to \"Upgrade\"";
    sed -i -e "s,Connection\ \$proxy_connection,Connection\ \"Upgrade\",ig" /etc/nginx/conf.d/default.conf;
fi

nginx -g 'daemon off;';
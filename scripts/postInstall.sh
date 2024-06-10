#set env vars
set -o allexport; source .env; set +o allexport;

#wait until the server is ready
echo "Waiting for software to be ready ..."
sleep 30s;

if [ -e "./initialized" ]; then
    echo "Already initialized, skipping..."
else
    target=$(docker-compose port cronicle 3012)

    login=$(curl http://${target}/api/user/login \
        -H 'accept: text/plain, */*; q=0.01' \
        -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
        -H 'cache-control: no-cache' \
        -H 'content-type: text/plain' \
        -H 'pragma: no-cache' \
        -H 'priority: u=1, i' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
        -H 'x-requested-with: XMLHttpRequest' \
        --data-raw '{"username":"admin","password":"admin"}')


    session_id=$(echo $login | jq -r '.session_id' )


    curl http://${target}/api/user/update \
        -H 'accept: text/plain, */*; q=0.01' \
        -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
        -H 'cache-control: no-cache' \
        -H 'content-type: text/plain' \
        -H 'pragma: no-cache' \
        -H 'priority: u=1, i' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
        -H 'x-requested-with: XMLHttpRequest' \
        --data-raw '{"username":"admin","full_name":"Administrator","email":"'${ADMIN_EMAIL}'","old_password":"admin","new_password":"'${ADMIN_PASSWORD}'","session_id":"'${session_id}'"}'

    curl http://${target}/api/app/update_conf_key \
        -H 'accept: text/plain, */*; q=0.01' \
        -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
        -H 'cache-control: no-cache' \
        -H 'content-type: text/plain' \
        -H 'pragma: no-cache' \
        -H 'priority: u=1, i' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
        -H 'x-requested-with: XMLHttpRequest' \
        --data-raw '{"id":"smtp_hostname","title":"smtp_hostname","key":"'${SMTP_HOST}'","description":"SMTP server (port 25 is used default)","optional":true,"type":"string","session_id":"'${session_id}'"}'


    curl http://${target}/api/app/update_conf_key \
        -H 'accept: text/plain, */*; q=0.01' \
        -H 'accept-language: fr-FR,fr;q=0.9,en-US;q=0.8,en;q=0.7,he;q=0.6,zh-CN;q=0.5,zh;q=0.4,ja;q=0.3' \
        -H 'cache-control: no-cache' \
        -H 'content-type: text/plain' \
        -H 'pragma: no-cache' \
        -H 'priority: u=1, i' \
        -H 'user-agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/125.0.0.0 Safari/537.36' \
        -H 'x-requested-with: XMLHttpRequest' \
        --data-raw '{"id":"email_from","title":"email_from","key":"'${SMTP_FROM}'","description":"Notification sender","optional":true,"type":"string","session_id":"'${session_id}'"}'
    touch "./initialized"
fi
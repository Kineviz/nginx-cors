# nginx-cors

A simple nginx proxy for enable CORS, it can support share proxy cookies.
 
** Docker Run: **

```bash
docker run -p 8080:80 -e TARGET_HOST=localhost:80 kineviz/nginx-cors
```

** Docker Compose: **

```yaml
version: '2'
services:
  nginx:
    image: kineviz/nginx-cors
    ports:
      - 8090:80
    environment:
      - TARGET_HOST=host.docker.internal:8080
      - ALLOW_HEADERS=nsid,token,code
```
### Example (for nebula)

** JavaScript Fetch Share Cookies Example**

>  The fetch should add  ** credentials: "include" ** to options.

e.g. Proxy site the localhost:8080, then use fetch request.

```
fetch("http://localhost:8080/api/login", {
  method: "POST",
  headers: {
    "Content-Type": "application/json",
  },
  credentials: "include",
  body: JSON.stringify({
    username:"demo",
    password:"demo"
  }),
}).then(logRes =>{
  console.log("Login success and write the cookie to domain localhost:8080");
  return fetch("http://localhost:8080/api/user/list", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
    credentials: "include",
  })
}).then(userListRes => {
  console.log("Got the user list :", userListRes); 
}).catch(e =>{
  console.error(e);
});
 
```

### Proxy Websocket only (For Neo4j)

```
docker run  -d \
--name ${PROJECT_DOMAIN} \
--restart always \
-p 8888:80 \
-e WS_ONLY=true \
-e TARGET_HOST=192.168.1.227:7687 \
kineviz/nginx-cors
```
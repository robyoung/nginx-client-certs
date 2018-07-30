# Client certificates in Nginx

This repository sets up a TLS PKI and a couple of Nginx Docker containers
to show the use of TLS client certificates with Nginx.

Build the PKI, start the containers and run the tests with `make test`

## Testing locally with curl

### Start up nginx

```bash
# Build the PKI
> make build-pki
> docker-compose up backend
```

### Enter the client container

```bash
> docker-compose run --rm client bash
```

### Test open vhost

This should work.

```bash
> curl http://open.backend.test
```

### Test secure vhost

This should fail because the signing CA is not in the client's trust store.

```bash
> curl https://secure.backend.test
```

This should work.

```bash
curl --cacert ./test-ca.pem https://secure.aam.test
```

### Test client cert validating vhost

This should fail because the signing CA is not in the client's trust store.

```bash
> curl https://client.backend.test
```

This should fail because the client cert is not presented.

```bash
curl --cacert ./test-ca.pem https://client.backend.test
```

This should work.

```bash
> curl --cert ./client.pem:password --cacert ./test-ca.pem https://client.backend.test
```


## Useful links

[How to create your own SSL certificate authority](https://deliciousbrains.com/ssl-certificate-authority-for-local-https-development/)
[Client-side SSL](https://gist.github.com/mtigas/952344)
[AWS API-Gateway client authentication and Nginx](https://stackoverflow.com/questions/33081349/aws-api-gateway-client-authentication-and-nginx)
[Nginx add client cert](https://serverfault.com/questions/622855/nginx-proxy-to-back-end-with-ssl-client-certificate-authentication)

### Relevant Nginx docs
[`ngx_http_proxy_module`](https://nginx.org/en/docs/http/ngx_http_proxy_module.html)
[`ngx_http_ssl_module`](https://nginx.org/en/docs/http/ngx_http_ssl_module.html)
[`ngx_stream_proxy_module`](https://nginx.org/en/docs/stream/ngx_stream_proxy_module.html) (not used here but useful if you want to proxy something other than HTTP)

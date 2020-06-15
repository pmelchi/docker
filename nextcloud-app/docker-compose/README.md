#Deploy the stack
~~~
docker stack deploy --compose-file=nextcloud-stack.yml nextcloud
~~~

#Build and push
~~
docker build -t pmelchi/nextcloud-web:example .
docker push pmelchi/nextcloud-web:example
~~
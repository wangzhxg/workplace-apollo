#!/bin/sh

# apollo config db info
apollo_config_db_url=jdbc:mysql://localhost:3306/ApolloConfigDB?characterEncoding=utf8
apollo_config_db_username=root
apollo_config_db_password=JfKSH34L/rMG4m4svbTBzTUlQlGTGSHMvy83tVvKvG5AGclxDWXfZhy8C4WYGWC47Qy9ZMqej14ke3fbJam/jw==
apollo_config_db_publickey=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAK5y3krb/m1i4MSLeoBjGWHbKgGnbAxgGJkDHA7LWVVTP4KT1txptg6A8e6Edj37yUO0XOubm2ad69FcWrTf8WMCAwEAAQ==

# apollo portal db info
apollo_portal_db_url=jdbc:mysql://localhost:3306/ApolloPortalDB?characterEncoding=utf8
apollo_portal_db_username=root
apollo_portal_db_password=JfKSH34L/rMG4m4svbTBzTUlQlGTGSHMvy83tVvKvG5AGclxDWXfZhy8C4WYGWC47Qy9ZMqej14ke3fbJam/jw==
apollo_portal_db_publickey=MFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBAK5y3krb/m1i4MSLeoBjGWHbKgGnbAxgGJkDHA7LWVVTP4KT1txptg6A8e6Edj37yUO0XOubm2ad69FcWrTf8WMCAwEAAQ==

# meta server url, different environments should have different meta server addresses
dev_meta=http://localhost:8080
fat_meta=http://localhost:8080
uat_meta=http://localhost:8080
pro_meta=http://localhost:8080

META_SERVERS_OPTS="-Ddev_meta=$dev_meta -Dfat_meta=$fat_meta -Duat_meta=$uat_meta -Dpro_meta=$pro_meta"

# =============== Please do not modify the following content =============== #
# go to script directory
cd "${0%/*}"

cd ..

# package config-service and admin-service
echo "==== starting to build config-service and admin-service ===="

mvn clean package -DskipTests -pl apollo-configservice,apollo-adminservice -am -Dapollo_profile=github -Dspring_datasource_url=$apollo_config_db_url -Dspring_datasource_username=$apollo_config_db_username -Dspring_datasource_password=$apollo_config_db_password -Dspring_datasource_publickey=$apollo_config_db_publickey

echo "==== building config-service and admin-service finished ===="

echo "==== starting to build portal ===="

mvn clean package -DskipTests -pl apollo-portal -am -Dapollo_profile=github,auth -Dspring_datasource_url=$apollo_portal_db_url -Dspring_datasource_username=$apollo_portal_db_username -Dspring_datasource_password=$apollo_portal_db_password -Dspring_datasource_publickey=$apollo_portal_db_publickey $META_SERVERS_OPTS

echo "==== building portal finished ===="

echo "==== starting to build client ===="

mvn clean install -DskipTests -pl apollo-client -am $META_SERVERS_OPTS

echo "==== building client finished ===="


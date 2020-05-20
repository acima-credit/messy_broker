# frozen_string_literal: true

# this is a generated file, to avoid over-writing it just delete this comment
begin
  require 'jar_dependencies'
rescue LoadError
  require 'tech/allegro/schema/json2avro/converter/0.2.9/converter-0.2.9.jar'
  require 'org/scala-lang/scala-reflect/2.12.10/scala-reflect-2.12.10.jar'
  require 'commons-cli/commons-cli/1.4/commons-cli-1.4.jar'
  require 'com/github/luben/zstd-jni/1.4.3-1/zstd-jni-1.4.3-1.jar'
  require 'org/glassfish/hk2/external/jakarta.inject/2.6.1/jakarta.inject-2.6.1.jar'
  require 'io/netty/netty-handler/4.1.45.Final/netty-handler-4.1.45.Final.jar'
  require 'jakarta/el/jakarta.el-api/3.0.3/jakarta.el-api-3.0.3.jar'
  require 'com/fasterxml/jackson/datatype/jackson-datatype-joda/2.4.5/jackson-datatype-joda-2.4.5.jar'
  require 'io/confluent/kafka-schema-registry-client/5.5.0/kafka-schema-registry-client-5.5.0.jar'
  require 'io/swagger/swagger-annotations/1.5.22/swagger-annotations-1.5.22.jar'
  require 'com/thoughtworks/paranamer/paranamer/2.8/paranamer-2.8.jar'
  require 'io/netty/netty-buffer/4.1.45.Final/netty-buffer-4.1.45.Final.jar'
  require 'io/netty/netty-common/4.1.45.Final/netty-common-4.1.45.Final.jar'
  require 'org/xerial/snappy/snappy-java/1.1.7.3/snappy-java-1.1.7.3.jar'
  require 'jakarta/annotation/jakarta.annotation-api/1.3.5/jakarta.annotation-api-1.3.5.jar'
  require 'org/glassfish/jersey/media/jersey-media-jaxb/2.30/jersey-media-jaxb-2.30.jar'
  require 'jakarta/ws/rs/jakarta.ws.rs-api/2.1.6/jakarta.ws.rs-api-2.1.6.jar'
  require 'org/glassfish/hk2/osgi-resource-locator/1.0.3/osgi-resource-locator-1.0.3.jar'
  require 'com/sun/activation/jakarta.activation/1.2.1/jakarta.activation-1.2.1.jar'
  require 'com/fasterxml/classmate/1.3.4/classmate-1.3.4.jar'
  require 'com/fasterxml/jackson/dataformat/jackson-dataformat-csv/2.10.2/jackson-dataformat-csv-2.10.2.jar'
  require 'org/apache/yetus/audience-annotations/0.5.0/audience-annotations-0.5.0.jar'
  require 'org/jboss/logging/jboss-logging/3.3.2.Final/jboss-logging-3.3.2.Final.jar'
  require 'org/scala-lang/modules/scala-java8-compat_2.12/0.9.0/scala-java8-compat_2.12-0.9.0.jar'
  require 'org/apache/commons/commons-compress/1.19/commons-compress-1.19.jar'
  require 'io/netty/netty-codec/4.1.45.Final/netty-codec-4.1.45.Final.jar'
  require 'org/scala-lang/modules/scala-collection-compat_2.12/2.1.3/scala-collection-compat_2.12-2.1.3.jar'
  require 'org/glassfish/jersey/ext/jersey-bean-validation/2.30/jersey-bean-validation-2.30.jar'
  require 'io/swagger/swagger-core/1.5.3/swagger-core-1.5.3.jar'
  require 'org/scala-lang/scala-library/2.12.10/scala-library-2.12.10.jar'
  require 'jakarta/activation/jakarta.activation-api/1.2.1/jakarta.activation-api-1.2.1.jar'
  require 'com/fasterxml/jackson/dataformat/jackson-dataformat-yaml/2.4.5/jackson-dataformat-yaml-2.4.5.jar'
  require 'com/fasterxml/jackson/datatype/jackson-datatype-jdk8/2.10.2/jackson-datatype-jdk8-2.10.2.jar'
  require 'org/hibernate/validator/hibernate-validator/6.0.17.Final/hibernate-validator-6.0.17.Final.jar'
  require 'io/netty/netty-resolver/4.1.45.Final/netty-resolver-4.1.45.Final.jar'
  require 'io/confluent/common-config/5.5.0/common-config-5.5.0.jar'
  require 'io/confluent/kafka-schema-serializer/5.5.0/kafka-schema-serializer-5.5.0.jar'
  require 'org/apache/commons/commons-lang3/3.2.1/commons-lang3-3.2.1.jar'
  require 'io/confluent/kafka-avro-serializer/5.5.0/kafka-avro-serializer-5.5.0.jar'
  require 'io/netty/netty-transport-native-unix-common/4.1.45.Final/netty-transport-native-unix-common-4.1.45.Final.jar'
  require 'io/confluent/common-utils/5.5.0/common-utils-5.5.0.jar'
  require 'com/yammer/metrics/metrics-core/2.2.0/metrics-core-2.2.0.jar'
  require 'com/fasterxml/jackson/core/jackson-core/2.10.2/jackson-core-2.10.2.jar'
  require 'org/yaml/snakeyaml/1.12/snakeyaml-1.12.jar'
  require 'org/apache/zookeeper/zookeeper-jute/3.5.7/zookeeper-jute-3.5.7.jar'
  require 'io/netty/netty-transport/4.1.45.Final/netty-transport-4.1.45.Final.jar'
  require 'io/netty/netty-transport-native-epoll/4.1.45.Final/netty-transport-native-epoll-4.1.45.Final.jar'
  require 'net/sf/jopt-simple/jopt-simple/5.0.4/jopt-simple-5.0.4.jar'
  require 'jakarta/xml/bind/jakarta.xml.bind-api/2.3.2/jakarta.xml.bind-api-2.3.2.jar'
  require 'com/fasterxml/jackson/core/jackson-annotations/2.10.2/jackson-annotations-2.10.2.jar'
  require 'com/typesafe/scala-logging/scala-logging_2.12/3.9.2/scala-logging_2.12-3.9.2.jar'
  require 'org/lz4/lz4-java/1.6.0/lz4-java-1.6.0.jar'
  require 'org/apache/zookeeper/zookeeper/3.5.7/zookeeper-3.5.7.jar'
  require 'org/slf4j/slf4j-api/1.8.0-beta4/slf4j-api-1.8.0-beta4.jar'
  require 'joda-time/joda-time/2.2/joda-time-2.2.jar'
  require 'io/swagger/swagger-models/1.5.3/swagger-models-1.5.3.jar'
  require 'org/glassfish/jersey/core/jersey-server/2.30/jersey-server-2.30.jar'
  require 'com/fasterxml/jackson/module/jackson-module-scala_2.12/2.10.2/jackson-module-scala_2.12-2.10.2.jar'
  require 'org/glassfish/jersey/core/jersey-client/2.30/jersey-client-2.30.jar'
  require 'com/fasterxml/jackson/core/jackson-databind/2.10.2/jackson-databind-2.10.2.jar'
  require 'org/glassfish/jakarta.el/3.0.2/jakarta.el-3.0.2.jar'
  require 'jakarta/validation/jakarta.validation-api/2.0.2/jakarta.validation-api-2.0.2.jar'
  require 'com/google/guava/guava/18.0/guava-18.0.jar'
  require 'org/apache/avro/avro/1.9.2/avro-1.9.2.jar'
  require 'org/apache/kafka/kafka_2.12/5.5.0-ccs/kafka_2.12-5.5.0-ccs.jar'
  require 'com/fasterxml/jackson/module/jackson-module-paranamer/2.10.2/jackson-module-paranamer-2.10.2.jar'
  require 'org/glassfish/jersey/core/jersey-common/2.30/jersey-common-2.30.jar'
  require 'org/slf4j/slf4j-simple/1.8.0-beta4/slf4j-simple-1.8.0-beta4.jar'
  require 'org/apache/kafka/kafka-clients/2.4.0/kafka-clients-2.4.0.jar'
end

if defined? Jars
  require_jar 'tech.allegro.schema.json2avro', 'converter', '0.2.9'
  require_jar 'org.scala-lang', 'scala-reflect', '2.12.10'
  require_jar 'commons-cli', 'commons-cli', '1.4'
  require_jar 'com.github.luben', 'zstd-jni', '1.4.3-1'
  require_jar 'org.glassfish.hk2.external', 'jakarta.inject', '2.6.1'
  require_jar 'io.netty', 'netty-handler', '4.1.45.Final'
  require_jar 'jakarta.el', 'jakarta.el-api', '3.0.3'
  require_jar 'com.fasterxml.jackson.datatype', 'jackson-datatype-joda', '2.4.5'
  require_jar 'io.confluent', 'kafka-schema-registry-client', '5.5.0'
  require_jar 'io.swagger', 'swagger-annotations', '1.5.22'
  require_jar 'com.thoughtworks.paranamer', 'paranamer', '2.8'
  require_jar 'io.netty', 'netty-buffer', '4.1.45.Final'
  require_jar 'io.netty', 'netty-common', '4.1.45.Final'
  require_jar 'org.xerial.snappy', 'snappy-java', '1.1.7.3'
  require_jar 'jakarta.annotation', 'jakarta.annotation-api', '1.3.5'
  require_jar 'org.glassfish.jersey.media', 'jersey-media-jaxb', '2.30'
  require_jar 'jakarta.ws.rs', 'jakarta.ws.rs-api', '2.1.6'
  require_jar 'org.glassfish.hk2', 'osgi-resource-locator', '1.0.3'
  require_jar 'com.sun.activation', 'jakarta.activation', '1.2.1'
  require_jar 'com.fasterxml', 'classmate', '1.3.4'
  require_jar 'com.fasterxml.jackson.dataformat', 'jackson-dataformat-csv', '2.10.2'
  require_jar 'org.apache.yetus', 'audience-annotations', '0.5.0'
  require_jar 'org.jboss.logging', 'jboss-logging', '3.3.2.Final'
  require_jar 'org.scala-lang.modules', 'scala-java8-compat_2.12', '0.9.0'
  require_jar 'org.apache.commons', 'commons-compress', '1.19'
  require_jar 'io.netty', 'netty-codec', '4.1.45.Final'
  require_jar 'org.scala-lang.modules', 'scala-collection-compat_2.12', '2.1.3'
  require_jar 'org.glassfish.jersey.ext', 'jersey-bean-validation', '2.30'
  require_jar 'io.swagger', 'swagger-core', '1.5.3'
  require_jar 'org.scala-lang', 'scala-library', '2.12.10'
  require_jar 'jakarta.activation', 'jakarta.activation-api', '1.2.1'
  require_jar 'com.fasterxml.jackson.dataformat', 'jackson-dataformat-yaml', '2.4.5'
  require_jar 'com.fasterxml.jackson.datatype', 'jackson-datatype-jdk8', '2.10.2'
  require_jar 'org.hibernate.validator', 'hibernate-validator', '6.0.17.Final'
  require_jar 'io.netty', 'netty-resolver', '4.1.45.Final'
  require_jar 'io.confluent', 'common-config', '5.5.0'
  require_jar 'io.confluent', 'kafka-schema-serializer', '5.5.0'
  require_jar 'org.apache.commons', 'commons-lang3', '3.2.1'
  require_jar 'io.confluent', 'kafka-avro-serializer', '5.5.0'
  require_jar 'io.netty', 'netty-transport-native-unix-common', '4.1.45.Final'
  require_jar 'io.confluent', 'common-utils', '5.5.0'
  require_jar 'com.yammer.metrics', 'metrics-core', '2.2.0'
  require_jar 'com.fasterxml.jackson.core', 'jackson-core', '2.10.2'
  require_jar 'org.yaml', 'snakeyaml', '1.12'
  require_jar 'org.apache.zookeeper', 'zookeeper-jute', '3.5.7'
  require_jar 'io.netty', 'netty-transport', '4.1.45.Final'
  require_jar 'io.netty', 'netty-transport-native-epoll', '4.1.45.Final'
  require_jar 'net.sf.jopt-simple', 'jopt-simple', '5.0.4'
  require_jar 'jakarta.xml.bind', 'jakarta.xml.bind-api', '2.3.2'
  require_jar 'com.fasterxml.jackson.core', 'jackson-annotations', '2.10.2'
  require_jar 'com.typesafe.scala-logging', 'scala-logging_2.12', '3.9.2'
  require_jar 'org.lz4', 'lz4-java', '1.6.0'
  require_jar 'org.apache.zookeeper', 'zookeeper', '3.5.7'
  require_jar 'org.slf4j', 'slf4j-api', '1.8.0-beta4'
  require_jar 'joda-time', 'joda-time', '2.2'
  require_jar 'io.swagger', 'swagger-models', '1.5.3'
  require_jar 'org.glassfish.jersey.core', 'jersey-server', '2.30'
  require_jar 'com.fasterxml.jackson.module', 'jackson-module-scala_2.12', '2.10.2'
  require_jar 'org.glassfish.jersey.core', 'jersey-client', '2.30'
  require_jar 'com.fasterxml.jackson.core', 'jackson-databind', '2.10.2'
  require_jar 'org.glassfish', 'jakarta.el', '3.0.2'
  require_jar 'jakarta.validation', 'jakarta.validation-api', '2.0.2'
  require_jar 'com.google.guava', 'guava', '18.0'
  require_jar 'org.apache.avro', 'avro', '1.9.2'
  require_jar 'org.apache.kafka', 'kafka_2.12', '5.5.0-ccs'
  require_jar 'com.fasterxml.jackson.module', 'jackson-module-paranamer', '2.10.2'
  require_jar 'org.glassfish.jersey.core', 'jersey-common', '2.30'
  require_jar 'org.slf4j', 'slf4j-simple', '1.8.0-beta4'
  require_jar 'org.apache.kafka', 'kafka-clients', '2.4.0'
end

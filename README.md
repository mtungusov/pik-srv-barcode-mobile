# Create topics

```
./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --create --replication-factor 1 --partitions 1 \
--topic 1s-references-podrazdeleniya

./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --create --replication-factor 1 --partitions 1 \
--topic 1s-references-sotrudniki
```

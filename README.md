# Create topics

```
./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --create --replication-factor 1 --partitions 1 \
--topic 1s-references-podrazdeleniya

./bin/kafka-topics.sh --zookeeper kafka.dev:2181 --create --replication-factor 1 --partitions 1 \
--topic 1s-references-sotrudniki
```


export ZK="kbr01dsk2.dsk2.picompany.ru:2181 kbr02dsk2.dsk2.picompany.ru:2181 kbr03dsk2.dsk2.picompany.ru:2181"

./bin/kafka-topics.sh --zookeeper $ZK --create --replication-factor 3 --partitions 1 \
--topic dev-1s-references-podrazdeleniya

./bin/kafka-topics.sh --zookeeper $ZK --create --replication-factor 3 --partitions 1 \
--topic dev-1s-references-sotrudniki

FROM   apache/kafka

USER   root
RUN    mkdir -p /etc/kafka/k8s
COPY   run /etc/kafka/k8s
RUN    chown -R appuser /etc/kafka/k8s && chmod +x /etc/kafka/k8s/run
USER   appuser
CMD    ["/etc/kafka/k8s/run"]


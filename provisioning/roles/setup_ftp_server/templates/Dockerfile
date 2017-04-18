FROM stilliard/pure-ftpd:hardened

CMD /run.sh -c 75 -C 20 -l puredb:/etc/pure-ftpd/pureftpd.pdb -E -j -R -P $PUBLICHOST -p 30000:30039 -d -d -O w3c:/var/log/pure-ftpd/transfer.log --tls=0

EXPOSE 21 30000-30039

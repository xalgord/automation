# Perform live check

```
cat new.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | tee live.txt
```

```
cat juice_subs.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | tee juicy-live.txt
```

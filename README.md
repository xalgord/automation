# Perform live check

```
cat new.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | anew live.txt
```

```
cat juice_subs.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | anew juicy-live.txt
```

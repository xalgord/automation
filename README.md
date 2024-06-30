# Perform live check

```
cat new.txt | httpx -sc -title -cl -probe | grep -v "FAILED" | tee live.txt
```

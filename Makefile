PORT ?= 8000
# Static site on S3 website bucket + CloudFront + Route53 alias. Infra was
# created once by hand with the aws CLI (bucket, distribution, DNS record);
# nothing here provisions it.
BUCKET = asteroids.leinonen.ninja
DISTRIBUTION_ID = E2GLS2U4ULLSAS

.PHONY: run
run:
	python3 -m http.server $(PORT)

.PHONY: deploy
deploy:
	aws s3 sync . s3://$(BUCKET) --delete --exclude "*" --include "index.html"
	aws cloudfront create-invalidation --distribution-id $(DISTRIBUTION_ID) --paths "/*" --no-cli-pager --query 'Invalidation.Status' --output text

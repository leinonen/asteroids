PORT ?= 8000
# Static site: private S3 bucket + CloudFront. Bucket, distribution and DNS live
# in github.com/leinonen/infrastructure. Pushes to main deploy via
# .github/workflows/deploy.yml.
BUCKET = asteroids.leinonen.ninja
DISTRIBUTION_ID = E2GLS2U4ULLSAS

.PHONY: run
run:
	python3 -m http.server $(PORT)

.PHONY: deploy
deploy:
	aws s3 sync . s3://$(BUCKET) --delete --exclude "*" --include "index.html"
	aws cloudfront create-invalidation --distribution-id $(DISTRIBUTION_ID) --paths "/*" --no-cli-pager --query 'Invalidation.Status' --output text

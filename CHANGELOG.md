# Changelog

Changes to this repo tend to be breaking.
We list all changes that you need to know about in this file, with instructions.

**Please remember to use the `--pull` flag reguarly to ensure that you have up-to-date and in-sync images.**

## 2020-12-01

Replaced `dynamodb` and `s3` with `aws`.
**All references to `dynamodb` or `s3` in your local stack.yml should be changed to `aws`.**

## 2020-11-13

Replaced `EXERCISM_INVOKE_VIA_DOCKER` environment variable with `EXERCISM_INVOKE_STATEGY` environment variable for `tooling-invoker` component.
**There is no action required unless you've previously overwridden this.**

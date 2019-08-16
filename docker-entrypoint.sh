#!/bin/bash


serverless config credentials --provider aws --key ${AWS_KEY} --secret ${AWS_SECRET}

exec "$@"
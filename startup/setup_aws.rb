#!/usr/bin/env ruby
# Only allow this to run in development
return unless ENV["EXERCISM_ENV"]=="development"

require "bundler/setup"
require "exercism_config"

puts "Create AWS/DynamoDB tables..."

Exercism.config.dynamodb_client = ExercismConfig::SetupDynamoDBClient.()

##################
# Setup local s3 #
##################

# We don't need this running for CI atm as none of our
# tests actually hit s3. Although we might choose to change this
unless ENV["EXERCISM_CI"]
  begin
    ExercismConfig::SetupS3Client.().create_bucket(bucket: Exercism.config.aws_iterations_bucket)
  rescue Seahorse::Client::NetworkingError => e
    puts "local S3 not up yet..."
    sleep 2 # slighty retry delaty
    retry
  end
end

########################
# Setup local dynamodb #
########################
%w[tooling_jobs tooling_jobs-test].each do |table_name|
  begin
    Exercism.config.dynamodb_client.delete_table(
      table_name: table_name
    )
  rescue Aws::DynamoDB::Errors::ResourceNotFoundException
  end
  puts "[x] #{table_name}"

  Exercism.config.dynamodb_client.create_table(
    table_name: table_name,
    attribute_definitions: [
      {
        attribute_name: "id",
        attribute_type: "S"
      }
    ],
    key_schema: [
      {
        attribute_name: "id",
        key_type: "HASH"
      }
    ],
    provisioned_throughput: {
      read_capacity_units: 1,
      write_capacity_units: 1
    }
  )

  Exercism.config.dynamodb_client.update_table(
    table_name: table_name,
    attribute_definitions: [
      {
        attribute_name: "job_status",
        attribute_type: "S"
      },
      {
        attribute_name: "created_at",
        attribute_type: "N"
      }
    ],
    global_secondary_index_updates: [
      {
        create: {
          index_name: "job_status", # required
          key_schema: [ # required
            {
              attribute_name: "job_status", # required
              key_type: "HASH" # required, accepts HASH, RANGE
            },
            {
              attribute_name: "created_at", # required
              key_type: "RANGE" # required, accepts HASH, RANGE
            }
          ],
          projection: { # required
            projection_type: "KEYS_ONLY"
          },
          provisioned_throughput: {
            read_capacity_units: 1, # required
            write_capacity_units: 1 # required
          }
        }
      }
    ]
  )
end

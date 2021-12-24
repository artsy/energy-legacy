## Environment Variables Configuration

Energy uses [shared configuration](https://github.com/artsy/README/blob/main/playbooks/development-environments.md#shared-configuration) to distribute common and sensitive configuration values. The [setup script](../scripts/prepare-env-vars) will download `.env.shared` from S3. Then it will add the environment variables ovverrides and any developer custom configuration from `.env.example` to `.env`. Finally, it will merge both into a `.env.dev` file that will be used for both builds.

> **Note**: Whenever you change an environment variable, you will need to rebuild the app again

## Add/Update remote environment variable

```
aws s3 cp s3://artsy-citadel/dev/.env.energy .env.shared
aws s3 cp .env.shared s3://artsy-citadel/dev/.env.energy
```

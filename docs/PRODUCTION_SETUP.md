# Production Setup

This document explains how to configure the application for production:

1. **API Keys**
   - Store OANDA API token in a secure vault.
   - Set environment variable `OANDA_API_KEY`.

2. **Certificate Pinning**
   - Update certificate SHA256 pins in certificate_pinning.dart.

3. **Flavors**
   - Build using `--flavor prod` for production builds.

4. **Security**
   - Ensure SSL pinning is enabled.

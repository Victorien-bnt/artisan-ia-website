#!/bin/bash

# Deploy to Netlify with automatic form handling
echo "🚀 Deploying Artisan'IA website to Netlify..."

# Build the project
echo "📦 Building project..."
npm run build

# Deploy to Netlify
echo "🌐 Deploying to Netlify..."
netlify deploy --prod --dir=.

echo "✅ Deployment complete!"
echo "📧 Form submissions will be sent to: victorienbinant@artisan-ia.fr"
echo "🔗 Website URL: https://artisan-ia.netlify.app"
